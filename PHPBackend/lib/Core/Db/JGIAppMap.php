<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;
use Util\EncUtil as EncUtil;


class JGIAppMap extends JGIAppDbObject {
	
	public $id;
    
    public $uid;
    
    public $title;
    
    public $description;
    
    public $status;
     
    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jgiapp_map");
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
            
            $input['id'] = "Map_".StrUtil::escapeBase64($rid);
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }

}

?>
