<?php
namespace Core\Controllers;

use Core\Db\JGIAppUser as User;
use Core\Db\JGIAppMapVersionSigner as Signer;
use Core\Db\JGIAppMapVersionSignLog as SignLog;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
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
        

        $result = $this->dbObject->loadBy($mapId, $versionNo);
       
        if (isset($result)){

            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result, JSON_NUMERIC_CHECK);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
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