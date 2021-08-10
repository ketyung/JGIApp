<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JGIAppDbObject as JGIAppDbObject;
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

        $result =  $this->dbObject->findBySQL( $sql , $params, true );

        if (count($result) > 0) {

            return $result[0]['id'];
        }

        return null;

    }
}
?>