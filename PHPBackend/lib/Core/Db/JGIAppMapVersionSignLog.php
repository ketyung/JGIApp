<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Core\Db\JGIAppMapVersionSigner as Signer;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;
use Util\EncUtil as EncUtil;

class JGIAppMapVersionSignLog extends JGIAppDbObject {
	
	public $id;
    
    public $mapId;
  
    public $versionNo;
    
    public $templateId;

    public $signers;

    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jgiapp_map_version_sign_log");
    }    
    

     
    private function genId(&$input){
        
        if (!isset($input['id'])){
            
            $rid = EncUtil::randomString(16);
            
            $count = $this->count(array('id'=>$rid));
            
            if ($count > 0)
            {
                $rid .= EncUtil::randomString(3). ($count + 1);
            }
            
            $input['id'] = "Slog_".StrUtil::escapeBase64($rid);
        }
    }
    
    public function insert(Array &$input){
      
        $this->genId($input);
        return parent::insert($input);
    }


    public function getIdIfExistsBy($mapId, $versionNo, $templateId){

        $sql =  "SELECT id FROM jgiapp_map_version_sign_log WHERE 
        map_id = :map_id AND version_no = :version_no AND template_id = :template_id";

        $params = array('map_id'=>$mapId, 'version_no'=>$versionNo, 'template_id' =>$templateId);

        $result =  $this->findBySQL( $sql , $params, true );

        if (count($result) > 0) {

            return $result[0]['id'];
        }

        return null;

    }



    public function loadBy($mapId, $versionNo){


       // Log::printRToErrorLog("$mapId::$versionNo");

        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("map_id", "=", " AND ", $mapId);
        $a[] = new SQLWhereCol("version_no", "=", "", $versionNo);
        
        $result = $this->findByWhere($a, true, " ORDER BY last_updated DESC", 0, 50);
    
        if (count($result) > 0){
   
            $result['signers'] = $this->getSigners($result[0]['id']);

            return $result;
        }

        return null;
       
    }



    private function getSigners($logId){

       
        $sql =  "SELECT a.uid, a.signed, a.date_signed, 
        concat(b.first_name, ' ', b.last_name) as name, 
        c.name as group_name  FROM jgiapp_map_version_signer a,
        jgiapp_user b, jgiapp_user_group c 
        WHERE a.log_id = :log_id
        AND (a.uid = b.id AND c.id = b.group_id) ";

        $params = array('log_id' => $logId);

        $signer_db = new Signer($this->db);
        $result = $signer_db->findBySQL($sql, $params, true);
    
        return $result;

    }
}
?>