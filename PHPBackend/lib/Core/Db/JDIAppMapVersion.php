<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JDIAppDbObject as JDIAppDbObject;
use Core\Db\JDIAppMapVersionItem as VersionItem;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;
use Util\EncUtil as EncUtil;


class JDIAppMapVersion extends JDIAppDbObject {
	
	public $id;
    
    public $versionNo;
    
    public $status;

    public $createdBy;

    public $latitude;

    public $longitude;

    public $levelOfDetail;
     
    public $items;

    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jdiapp_map_version");
    }


    /// default first 50, will modify later
    public function findByUserId($uid, $limit = 0, $offset = 50){
    
        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("created_by", "=", "", $uid);

        $res = $this->findByWhere($a, true, " ORDER BY last_updated DESC", $limit, $offset);
        
        return $res;
    }
    

    public function loadBy($id, $versionNo) {

        $pk = array ('id'=>$id, 'version_no'=>$versionNo);

        if ( $this->findByPK($pk)) {

            $this->loadItems($id, $versionNo);

            return true ;
        } 

        return false ;

    }

    private function loadItems($mapId, $versionNo){

        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("map_id", "=", " AND ", $mapId);
        $a[] = new SQLWhereCol("version_no", "=", "", $versionNo);
        
        $itemdb = new VersionItem($this->db);

        
        $items = array();

        $res = $itemdb->findByWhere($a, true, " ORDER BY last_updated DESC");
       
      //  Log::printRToErrorLog($res);

        foreach ($res as $row) {

            $item = new VersionItem($this->db);
            $item->loadResultToProperties($row);

            $item->loadPoints();

            array_push($items, $item);
        }

        $this->items = $items; 

    }


    private function genVersionNo(&$input){
        
        if ( isset($input['id'])){
            
            $map_id = $input['id'];
            

            $a = new ArrayOfSQLWhereCol();
            $a[] = new SQLWhereCol("id", "=", "", $map_id);
    

            $versionNo = $this->findCountByWhere($a, false) + 100;
             
            
            $input['version_no'] = $versionNo ;
        
           // Log::printRToErrorLog($input);
            
        }
    }

    public function insert(Array &$input){
      
        $this->genVersionNo($input);
        return parent::insert($input);
    }



}
?>