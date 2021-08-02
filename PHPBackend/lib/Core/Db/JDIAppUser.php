<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JDIAppDbObject as JDIAppDbObject;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\EncUtil as EncUtil;
use Util\KeyManager as KM;
use Util\Log as Log;
use Util\StrUtil as StrUtil;


class JDIAppUser extends JDIAppDbObject {
	
    const ERROR_DUPLICATED_EMAIL = 'Duplicated Email!';
    
    const ERROR_DUPLICATED_PHONE_NUMBER = 'Duplicated Phone Number!';

	public $id;
    
    public $firstName;
    
    public $lastName;
    
    public $accountType;
    
    public $dob;
    
    public $email;
    
    public $phoneNumber;
    
    public $countryCode;
    
    public $seed;
    
    public $stat;
    
    public $lastStatTime;
    
    
    
	public function __construct($db)
    {
		parent::__construct($db, "tzdb_user");
    }

	
	public function generateId ( Array $input ){
		
		$lastName = $input['last_name'] ?? EncUtil::randomString(3);
		$lastName = trim(substr($lastName, 0, 3) ?? EncUtil::randomString(3) );
		
		$rstr = EncUtil::randomString(8);
		
		$id = $lastName."_$rstr";
		
		$count = $this->count(array('id'=>$id));
		
		if ($count > 0)
		{
			$id .= EncUtil::randomString(3). ($count + 1);
		}
		
        // replace / generated by base64
        $id =  StrUtil::escapeBase64($id);
		return $id;
	}
	
	// will need to handle this 
	private function encrypt(Array &$input){
		
        $seed = null;
		$key = KM::key($seed, true);
        $nonce = KM::nonce($seed, true);
       
        if (isset($input['email']))
            $input['email'] = EncUtil::encrypt($input['email'], $key, $nonce);
		
        if (isset($input['phone_number']))
            $input['phone_number'] = EncUtil::encrypt($input['phone_number'], $key, $nonce);
		
        $input['seed'] = $seed;
        
 	}
    
    public function findBy($pk){
        
        $res = parent::findBy($pk);
        if (count($res) > 0){
            
            $row = $res[0];
          
            $this->loadResultToProperties($row);
            
            $this->decrypt();
           
            return true;
        }
        
        return false;
        
    }
    
    
    public function findByPhone($number){
        
        $input = array();
        $input['phone_number'] = $number ;
        $foundRes = null;
        if ($this->existsByEC($input, 'phone_number', $foundRes )){
            
            $row = $foundRes[0];
            
            $this->loadResultToProperties($row);
            
            $this->decrypt();
            
            return true;
        }
        
        
        return false;
    }
    
    
    public function findByEmail($email){
        
        $input = array();
        $input['email'] = $email ;
        $foundRes = null;
        if ($this->existsByEC($input, 'email', $foundRes )){
            
            $row = $foundRes[0];
            
            $this->loadResultToProperties($row);
            
            $this->decrypt();
            
            return true;
        }
        
        
        return false;
    }
    
    private function decrypt(){
        
        $key = KM::key($this->seed, true);
        $nonce = KM::nonce($this->seed, true);
        $this->phoneNumber = EncUtil::decrypt($this->phoneNumber, $key, $nonce);
        $this->email = EncUtil::decrypt($this->email, $key, $nonce);
    }
    
	
    
    protected function existsByEC( Array $input, $col, &$foundRes = null ) {
        
        $keysCount = count(KM::keys());
        
        for ($i = 0; $i < $keysCount ; $i++){
            
            //error_log("seed::$i");
            if ( $this->existsByWithSeed($i, $input, $col, ($i==0) , $foundRes) ){
                
                $foundSeed = $i;
                return true ;
            }
        }
        
        return false ;
    }
    
	protected function existsByWithSeed($seed, Array $input, $col, $recreateStatement , &$foundRes = null){
	
		$a = new ArrayOfSQLWhereCol();
		
        $key = KM::key($seed, true);
        $nonce = KM::nonce($seed, true);
    
		$val =  EncUtil::encrypt($input[$col], $key, $nonce);
		
		$a[] = new SQLWhereCol($col, "=", "AND" , $val ?? "");

		$res = $this->findByWhere( $a,  $recreateStatement  );
        
        $foundRes = $res ;
        
		return count($res) > 0 ;
	}
	
	
	
	public function insert(Array &$input, $checkDuplicatePhoneNumber = true, $checkDuplicateEmail = true  ){
		
        
        if ($checkDuplicatePhoneNumber){
            
            if ($this->existsByEC($input, 'phone_number')){
                
                $this->lastErrorMessage = self::ERROR_DUPLICATED_PHONE_NUMBER;
                
                return DbObject::ERROR_ON_TX;
            }
            
        }
        
		
        if ($checkDuplicateEmail) {
       
            if ($this->existsByEC($input, 'email')){
                
                $this->lastErrorMessage = self::ERROR_DUPLICATED_EMAIL;
                return DbObject::ERROR_ON_TX;
            }
        }
        
		$this->encrypt($input);
		$input['id'] = $this->generateId($input);
		return parent::insert($input);
	}
    
    
    public function update(Array $input, $toRecreateStatement = false, $toEncrypt = true  )
    {
        if ($toEncrypt)
            $this->encrypt($input);
        
        return parent::update($input, $toRecreateStatement  );
    }
    
    
	
	static function testInsertUsers($conn){
		
		$input = array('first_name'=>'Ket Yung', 'last_name'=>'Chee',
		'email'=>'ketyung@techchee.com', 'phone_number'=>'+60138634848');
		
		$u = new JDIAppUser($conn);
		echo "<p>".$u->insert($input)." : inserted!</p>";
		
        if ($u->hasErrorMessage()) echo "<p>".$u->getErrorMessage()."</p>";
		
		$input = array('first_name'=>'Abigail', 'last_name'=>'Vanc Chee',
		'email'=>'abigail@techchee.com', 'phone_number'=>'+60128119009');
	
		echo "<p>".$u->insert($input)." : inserted!</p>";
        
        if ($u->hasErrorMessage()) echo "<p>".$u->getErrorMessage()."</p>";
        
	}
	
    
    static function exists($id, $db) {
        $u = new JDIAppUser($db);
        $pk['id'] = $id;
        return $u->findBy($pk);
    }
}

?>
