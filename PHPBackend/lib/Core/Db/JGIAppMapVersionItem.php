<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Core\Db\JGIAppMapVersionIpoint as ItemPoint;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;
use Util\EncUtil as EncUtil;


class JGIAppMapVersionItem extends JGIAppDbObject {
	
	public $id;
    
    public $mapId;
  
    public $versionNo;
    
    public $itemType;

    public $createdBy;

    public $color;
   
    public $points;

    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jgiapp_map_version_item");
    }


    /// default first 50, will modify later
    public function findByUserId($uid, $limit = 0, $offset = 50){
    
        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("created_by", "=", "", $uid);

        $res = $this->findByWhere($a, true, " ORDER BY last_updated DESC", $limit, $offset);
        
        return $res;
    }
    


    function loadPoints(){

        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("item_id", "=", "", $this->id);
        

        $itemPoint = new ItemPoint($this->db);

        $itemPoints = array();

        $res = $itemPoint->findByWhere($a, true, " ORDER BY id");
       
        foreach ($res as $row) {

            $point = new ItemPoint($this->db);
            $point->loadResultToProperties($row);
            array_push($itemPoints, $point);
      
        }

        $this->points = $itemPoints;

    }




    private function genId(&$input){
        
        if (!isset($input['id'])){
            
            $rid = EncUtil::randomString(16);
            
            $count = $this->count(array('id'=>$rid));
            
            if ($count > 0)
            {
                $rid .= EncUtil::randomString(3). ($count + 1);
            }
            
            $input['id'] = "MI_".StrUtil::escapeBase64($rid);
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }

}
?>