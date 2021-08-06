<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JDIAppDbObject as JDIAppDbObject;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;

class JDIAppMapVersionIpoint extends JDIAppDbObject {
	
	public $itemId;
    
    public $id;
  
    public $x;

    public $y;

    public $wkid;
   
    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jdiapp_map_version_ipoint");
    }


    /// default first 50, will modify later
    public function findByItemId($uid, $limit = 0, $offset = 50){
    
        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("item_id", "=", "", $uid);

        $res = $this->findByWhere($a, true, " ORDER BY last_updated DESC", $limit, $offset);
        
        return $res;
    }
    


    private function genId(&$input){
        
        if (!isset($input['id']) && isset($input['item_id'])){
            
            $item_id = $input['item_id'];
            
            $id = $this->count(array('item_id'=>$item_id)) + 1;
             
            $input['id'] = $id ;
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }

}
?>