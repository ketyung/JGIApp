<?php
/**
 * CopyRight (c) 2021 Ket Yung Chee. MIT License
 */
namespace Core\Db;

use Db\DbObject as DbObject;

class JGIAppDbObject extends DbObject {

    protected $rowArray;
    
    public function getRowArray(){
        
        return $this->rowArray;
    }
    
    
    public function findByPK($pk, $loadAsRowArray = false ){
        
        $result = parent::findBy($pk);
        
        if (count($result) > 0){
           
            $row = $result[0];
           
            if ($loadAsRowArray) {
                
                $this->rowArray = $row;
            }
            else {
           
                $this->loadResultToProperties($row);
            }
            return true ;
        }
        
        return false ;
    }
    
    
    public function insert(Array &$input){
        
        if (!isset($input['last_updated'])) {
        
            $input['last_updated'] = date('Y-m-d H:i:s');
        }
        
        return parent::insert($input);
    }

    public function update(Array $input, $toRecreateStatement = false)
    {
        
        if (!isset($input['last_updated'])) {
        
            $input['last_updated'] = date('Y-m-d H:i:s');
        }
        
        return parent::update ($input, $toRecreateStatement);
        
    }
    
}
?>
