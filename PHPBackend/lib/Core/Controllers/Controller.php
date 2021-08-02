<?php
namespace Core\Controllers;

use Core\Controllers\RequestMethod as RM;
use Util\Log as Log;
use Util\StrUtil as StrUtil;


class Controller {

    protected $db;

    protected $requestMethod;
 
    protected $dbObject;
    
    protected $params;
 
    public function __construct($db, $requestMethod = "", $params = null)
    {
        $this->db = $db;
        $this->requestMethod = $requestMethod;
        $this->params = $params; 
        $this->createDbObject();
    }
    
    protected function createDbObject(){
    
    }
    
    
    
    public function processRequest(){
        
        
        $response = array();
        
        switch ($this->requestMethod) {
           
            case RM::GET:
                
                $response = $this->getDbObjects();
       
                break;
                
            case RM::POST:
                
                $response = $this->createDbObjectFromRequest();
                break;
                
            case RM::PUT:
                
                $response = $this->updateDbObjectFromRequest();
                break;
                
            case RM::DELETE:
                
                $response = $this->deleteDbObject();
                break;
                
            default:
                
                $response = $this->notFoundResponse();
                break;
        }
        
        
        if (isset($response['status_code_header']))
            header($response['status_code_header']);
        
        if (isset($response['body']))
            echo $response['body'];
    
    
        //Log::printRToErrorLog($response);
       
    }
    
    
    protected function getDbObjects(){
        
        
    }
    
    
    protected function createDbObjectFromRequest(){
        
    }
    
    
    protected function updateDbObjectFromRequest(){
        
    }
    
    protected function deleteDbObject(){
        
    }

    
    protected function getInput( $fromJson = true ){
        
        $input = null ;
        
        if ($fromJson){
            
            $input =  (array) json_decode(file_get_contents('php://input'), TRUE) ;
        }
        else {
            parse_str(file_get_contents('php://input'), $input );
        }
            
        return $input;
    }
    
    
    protected function notFoundResponse()
    {
        $response['status_code_header'] = 'HTTP/1.1 404 Not Found';
        $response['body'] = 404 ; 
        return $response;
    }
    
    protected function dummyResponse()
    {
        $response['status_code_header'] = 'HTTP/1.1 200 OK';
        $response['body'] = json_encode(array('text'=>'Hello World'));
        return $response;
    }
    
    
    
    protected function validate($input, Array $fields, &$errorMessage = null )
    {
        foreach ( $fields as $field ){
            
            if (!isset($input[$field]) || trim($input[$field]) == '') {
                
                $f = StrUtil::snakeCaseToWords($field);
                $errorMessage = "\"$f\" is blank";
                
                return false ;
            }
        }
        
        return true ;
    }
}
?>
