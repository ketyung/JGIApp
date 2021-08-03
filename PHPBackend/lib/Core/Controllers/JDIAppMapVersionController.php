<?php
namespace Core\Controllers;

use Core\Db\JDIAppUser as User;
use Core\Db\JDIAppMap as Map;
use Core\Db\JDIAppMapVersion as MapVersion;
use Core\Db\JDIAppMapVersionNote as MapNote;
use Core\Db\JDIAppMapVersionItem as VersionItem;
use Core\Db\JDIAppMapVersionIpoint as VersionIpoint;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Util\Log as Log;

class JDIAppMapVersionController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new MapVersion($this->db);
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
        
        if ($param1 == 'user' && $param2 != '' ){
        
            return $this->getByUserId($param2);
        }
        else
        if ($param1 == 'id' && $param2 != '' ){
        
            return $this->getBy($param2, $param3);
        }

        else {
         
            return $this->notFoundResponse();
        }
        
    
    }
    

    private function getBy($id, $versionNo){
        
        if ($this->dbObject->loadBy($id, $versionNo)){

            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = $this->dbObject->toJson();
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }
    
    private function getByUserId($userId){
        
        $result = $this->dbObject->findByUserId($userId) ;
        
        if (count($result) > 0){
       
            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }
    
    
    
}

?>