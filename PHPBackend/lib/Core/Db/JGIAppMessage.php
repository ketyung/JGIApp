<?php
namespace Core\Db;

use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Util\Log as Log;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\EncUtil as EncUtil;
use Util\StrUtil as StrUtil;

class JGIAppMessage extends JGIAppDbObject {
    
    public $id;
    public $uid;
    public $itemId;
    public $title;
    public $subTitle;
    public $type;
    public $lastUpdated;
    

    public function __construct($db)
    {
        parent::__construct($db, "jgiapp_message");
    }
    
    
    /// default first 50, will modify later
    public function findByUserId($uid, $limit = 0, $offset = 50){
    
        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("uid", "=", "", $uid);

        $res = $this->findByWhere($a, true, " ORDER BY last_updated DESC", $limit, $offset);
        
        return $res;
    }
    
    
    private function genId(&$input){
        
        if (!isset($input['id'])){
            
            $rid = EncUtil::randomString(16);
            
            $count = $this->count(array('id'=>$rid));
            
            if ($count > 0)
            {
                $rid .= EncUtil::randomString(3). ($count + 1);
            }
            
            $input['id'] = "Mesg_".StrUtil::escapeBase64($rid);
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }

    
}
?>
