<?php
namespace Core\Controllers;

use Core\Db\JGIAppUser as User;
use Core\Db\JGIAppMapVersionSigner as Signer;
use Core\Db\JGIAppMapVersionSignLog as SignLog;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;


class JGIAppMapVersionSignLogController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new SignLog($this->db);
    }
    
    protected function getDbObjects(){
        
        $param1 = "";
        $param2 = "";
        $param3 = "";
        
        
       // Log::printRToErrorLog($this->params);
       
        if (isset($this->params)) {
            
            if (isset($this->params[0])){
                $param1 = $this->params[0];
            }
            
            if (isset($this->params[1])){
                $param2 = $this->params[1] ;
            }
          
            if (isset($this->params[2])){
                $param3 = $this->params[2] ;
            }
          
        }
        
        if ($param1 == 'mapVersion' && $param2 != '' ){
        
            return $this->getSignLog($param2, $param3);
            
        }
        else {
         
            return $this->notFoundResponse();
        }
        
    
    }
    
    
    private function getSignLog($mapId, $versionNo){
        

        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("map_id", "=", " AND ", $mapId);
        $a[] = new SQLWhereCol("version_no", "=", "", $versionNo);
        
        $result = $this->dbObject->findByWhere($a, true, " ORDER BY last_updated DESC", 0, 50);
    
       
        if (count($result) > 0){
   
            $result['signers'] = $this->getSigners($result[0]['id']);


            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result, JSON_NUMERIC_CHECK);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }

    private function getSigners($logId) {

        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("log_id", "=", " AND ", $logId);
        
        $signer_db = new Signer($this->db);
        $result = $signer_db->findByWhere($a, true, " ORDER BY last_updated DESC", 0, 50);
    
        return $result;

    } 

    

    protected function createDbObjectFromRequest(){
    

        $param1 = "";
       
        if (isset($this->params)) {
            
            if (isset($this->params[0])){
                $param1 = $this->params[0];
            }
        }
     
        $input = $this->getInput();
      
        StrUtil::arrayKeysToSnakeCase($input);


        $input['id'] = $this->dbObject->getIdIfExistsBy(
            $input['map_id'], $input['version_no'], $input['template_id']
        );
           
        if ( $this->dbObject->save($input) > 0 ) {

            if ( isset($input['signers'])) {

                $signers = $input['signers'];
                $mapId = $input['map_id'];
                $versionNo = $input['version_no'];


                foreach ( $signers as $signer) {

                    $signer_db = new Signer($this->db);
                    
                    $signer['log_id'] = $input['id'];
                    $signer['map_id'] = $mapId;
                    $signer['version_no'] = $versionNo;
                    
                    if ( isset($signer['date_signed'])){

                        // use server's date instead
                        $signer['date_signed'] = date('Y-m-d H:i:s');
                    }

                    
                    $signer_db->save($signer);

                }
            }
        }

    }
    
}

?>