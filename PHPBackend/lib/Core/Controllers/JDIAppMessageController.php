<?php
namespace Core\Controllers;

use Core\Db\JDIAppUser as User;
use Core\Db\JDIAppMessage as Message;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Util\Log as Log;

class JDIAppMessageController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new Message($this->db);
    }
    
    protected function getDbObjects(){
        
        $param1 = "";
        $param2 = "";
        
        
       // Log::printRToErrorLog($this->params);
       
        if (isset($this->params)) {
            
            if (isset($this->params[0])){
                $param1 = $this->params[0];
            }
            
            if (isset($this->params[1])){
                $param2 = $this->params[1] ;
            }
          
        }
        
        if ($param1 == 'user' && $param2 != '' ){
        
            return $this->getByUserId($param2);
            
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
