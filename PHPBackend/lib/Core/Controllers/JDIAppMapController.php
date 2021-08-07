<?php
namespace Core\Controllers;

use Core\Db\JDIAppUser as User;
use Core\Db\JDIAppMap as Map;
use Core\Db\JDIAppMapVersion as MapVersion;
use Core\Db\JDIAppMapVersionNote as VersionNote;
use Core\Db\JDIAppMapVersionItem as VersionItem;
use Core\Db\JDIAppMapVersionIpoint as VersionIpoint;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Core\Controllers\JDIAppMapVersionController as MapVersionController;
use Util\Log as Log;
use Util\StrUtil as StrUtil;

class JDIAppMapController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new Map($this->db);
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
    

    private function getBy($id){
        
        $pk = array('id'=>$id);

        $result = $this->dbObject->findBy($pk);

        if (count($result) > 0){


            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }
    
    private function getByUserId($userId){
        
        $result = $this->dbObject->findByUserId($userId) ;
        
      //  Log::printRToErrorLog($userId);

        if (count($result) > 0){
       
            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }
    
    

    protected function createDbObjectFromRequest(){
    
        $input = $this->getInput();
      
        StrUtil::arrayKeysToSnakeCase($input);
       
        $response['status_code_header'] = 'HTTP/1.1 201 Create';
      
        
                                            
        if ($this->dbObject->insert($input) > 0){
            
            $this->createMapVersionIfExists($input);

            $a = array('status'=>1, 'id'=>$input['id'], 'text'=>'Created!');//, 'returnedObject'=> $input);
            $response['body'] = json_encode($a);
        
        }
        else {
            $response['body'] = json_encode(array('status'=> -1 , 'id'=>null, 'text'=>$this->dbObject->getErrorMessage()));
        }
        
       
        return $response;
        
    }
    

    protected function createMapVersionIfExists($input) {

       
        if ( isset($input['map_version'])){

            $mapVersion = $input['map_version'];

            $versiondb = new MapVersion($this->db);

            $mapVersion['id'] = $input['id'];

            if (!isset($mapVersion['version_no'])){

                $mapVersion['version_no'] = 100;
            }

            if (!isset($mapVersion['created_by'])){

                $mapVersion['created_by'] = $input['uid'];
            }



            //Log::printRToErrorLog($mapVersion);

            if ( $versiondb->insert($mapVersion) > 0 ){


                MapVersionController::createNotesIfAny($mapVersion, $this->db);

                MapVersionController::createItemsIfAny($mapVersion, $this->db);

            }
            

        }

    }

   

}

?>