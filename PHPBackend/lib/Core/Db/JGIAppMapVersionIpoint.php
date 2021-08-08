<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;

class JGIAppMapVersionIpoint extends JGIAppDbObject {
	
	public $itemId;
    
    public $id;
  
    public $x;

    public $y;

    public $wkid;
   
    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jgiapp_map_version_ipoint");
    }


    /// default first 50, will modify later
    public function findByItemId($item_id, $limit = 0, $offset = 50){
    
        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("item_id", "=", "", $item_id);

        $res = $this->findByWhere($a, true, " ORDER BY last_updated DESC", $limit, $offset);
        
        return $res;
    }
    


    private function genId(&$input){
        
        if (!isset($input['id']) && isset($input['item_id'])){
            
            $item_id = $input['item_id'];
            

            $a = new ArrayOfSQLWhereCol();
            $a[] = new SQLWhereCol("item_id", "=", "", $item_id);
    

            $id = $this->findCountByWhere($a, false) + 1;
             
            
            $input['id'] = $id ;
        
           // Log::printRToErrorLog($input);
            
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }

}
?>