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
use Util\StrUtil as StrUtil;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Db\SQLWhereCol as SQLWhereCol;



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
        
            if ($param3 != '') {

                return $this->getBy($param2, $param3);
    
            }
            else {

                return $this->getByIdOnly($param2);
            }

        }

        else {
         
            return $this->notFoundResponse();
        }
        
    
    }


    private function getByIdOnly($id) {


        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("id", "=", "", $id);

        $res = $this->dbObject->findByWhere($a, true, " ORDER BY last_updated DESC", 0, 50);
    
        if (count($res) > 0 ){

            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($res, JSON_NUMERIC_CHECK);
            return $response;
    
        }
        else {

            return $this->notFoundResponse();
      
        }
    }

    

    private function getBy($id, $versionNo){
        
        if ($this->dbObject->loadBy($id, $versionNo)){

            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = $this->dbObject->toJson(null, JSON_NUMERIC_CHECK);
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
    


    // insert new map version
    protected function createDbObjectFromRequest(){
    
        $input = $this->getInput();
      
        StrUtil::arrayKeysToSnakeCase($input);
       
        $response['status_code_header'] = 'HTTP/1.1 201 Create';
      
                         
        if ($this->dbObject->insert($input) > 0){
            
            self::createNoteIfAny($input, $this->db);
            self::createItemsIfAny($input, $this->db);

            $a = array('status'=>1, 'id'=>$input['id'], 'text'=>'Created!');//, 'returnedObject'=> $input);
            $response['body'] = json_encode($a);
        
        }
        else {
            $response['body'] = json_encode(array('status'=> -1 , 'id'=>null, 'text'=>$this->dbObject->getErrorMessage()));
        }
        
       
        return $response;
        
    }


    static function createNoteIfAny($mapVersion, $db) {

        // insert note if any 
        if (isset($mapVersion['note'])) {

            $note = $mapVersion['note'] ;
            $note['map_id'] = $mapVersion['id'];
            $note['version_no'] = $mapVersion['version_no'];
            $note['uid'] = $mapVersion['created_by'];
            
            $notedb = new VersionNote($db);
            $notedb->insert($note);

        }

    }



    // insert items attached to this map version
    static function createItemsIfAny ( $mapVersion, $db ) {

        if ( isset($mapVersion['items'])) {

            $versionItems = $mapVersion['items'];

            $itemdb = new VersionItem ($db);
               
            // insert each item if any 
            foreach ($versionItems as $item) {

                $item['map_id'] = $mapVersion['id'];
                $item['version_no'] = $mapVersion['version_no'];
                $item['created_by'] = $mapVersion['created_by'];

                if ( $itemdb->insert($item) > 0 ){

                    // insert each point if any
                    $pointdb = new VersionIpoint($db);
                      
                    if ( isset($item['points'])) {

                        $points = $item['points'];

                        foreach ( $points as $point) {

                            $point['item_id'] = $item['id'];
                            
                            $pointdb->insert($point);
                        }

                    }
                }
                
            }
        }
    }
    
    
}

?>