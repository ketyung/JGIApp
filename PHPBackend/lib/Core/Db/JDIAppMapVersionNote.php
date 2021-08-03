<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JDIAppDbObject as JDIAppDbObject;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;

class JDIAppMapVersionNote extends JDIAppDbObject {
	
	public $id;
    
    public $mapId;
  
    public $versionNo;
    
    public $uid;

    public $title;
   
    public $note;
     
    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jdiapp_map_version_note");
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
            
            $input['id'] = "Note_".StrUtil::escapeBase64($rid);
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }

}
?>