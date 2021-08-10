<?php
namespace Core\Controllers;

use Core\Db\JGIAppUser as User;
use Core\Db\JGIAppMapVersionSigner as Signer;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Util\Log as Log;
use Util\StrUtil as StrUtil;


class JGIAppMapVersionSignerController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new Signer($this->db);
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
        
        if ($param1 == 'mapVersions' && $param2 != '' ){
        
            return $this->getMapVersionsById($param2, $param3);
            
        }
        else {
         
            return $this->notFoundResponse();
        }
        
    
    }
    
    
    private function getMapVersionsById($userId, $signed){
        

        $sql =  "SELECT a.id, a.version_no as versionNo, 
        a.created_by as createdBy, a.last_updated as lastUpdated FROM jgiapp_map_version a, 
        jgiapp_map_version_signer b WHERE (a.id = b.map_id AND a.version_no = b.version_no)  
        AND b.uid = :uid ";

        $params = array('uid'=>$userId);

        if ($signed=='signed'){

            $sql .= " AND b.signed = :signed";
            $params['signed'] = 'Y';
        }
        else
        if ($signed=='unsigned'){

            $sql .= " AND b.signed != :signed";
            $params['signed'] = 'Y';
        
        }

       // Log::printRToErrorLog($sql);
        

        $sql.=" ORDER BY a.last_updated DESC ";

        $result =  
        $this->dbObject->findBySQL( $sql , $params, true );
         
       
        if (count($result) > 0){
       
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
   

        if ($param1 == 'multiple') {

         //   Log::printRToErrorLog($input);

            if ( isset($input['signers'])) {

                $signers = $input['signers'];
                $mapId = $input['map_id'];
                $versionNo = $input['version_no'];

            

                foreach ( $signers as $signer) {

                    $signer_db = new Signer($this->db);
                    
                    $signer['map_id'] = $mapId;
                    $signer['version_no'] = $versionNo;
                  //  Log::printRToErrorLog($signer);

                   
                    $signer_db->insert($signer);

                }
            }


        }
        else {
                        
            $response['status_code_header'] = 'HTTP/1.1 201 Created';
        
            if ($this->dbObject->insert($input) > 0){
                
                $a = array('status'=>1, 'id'=>$input['id'], 'text'=>'Created!');
                
                $response['body'] = json_encode($a);
            
            }
            else {
                $response['body'] = json_encode(array('status'=> -1 , 'id'=>null, 'text'=>$this->dbObject->getErrorMessage()));
            }
            
        
            return $response;
      

        }



    }
    
}

?>