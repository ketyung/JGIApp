<?php
namespace Core\Controllers;

use Core\Db\JDIAppUser as User;
use Core\Db\JDIAppUserGroup as UserGroup;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Util\Log as Log;

class JDIAppUserGroupController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new UserGroup($this->db);
    }
    
    protected function getDbObjects(){
        
        $param1 = "";
       
        if (isset($this->params)) {
            
            if (isset($this->params[0])){
                $param1 = $this->params[0];
            } 
        }
        
        if ($param1 == 'all'){
        
            return $this->getAll();
            
        }
        else {
         
            return $this->notFoundResponse();
        }
        
    
    }
    
    
    private function getAll(){
        
        $result = $this->dbObject->findAll() ;
        
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
