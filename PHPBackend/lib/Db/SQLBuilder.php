<?php
/**
 * CopyRight (c) 2021 Ket Yung Chee. MIT License
 */
namespace Db;
use Util\Log as Log;

class SQLWhereCol {

	public $name;
	
	public $comparator = "=";
	
	public $operator = "AND";
	
	public $value;
	
	
	public function __construct($name, $comparator = "=", $operator = "AND", $value = ""){
		
		$this->name = $name;
		$this->comparator = " ".trim($comparator). " ";
		$this->operator = $operator;
		$this->value = $value ;
	}
}


class ArrayOfSQLWhereCol extends \ArrayObject {
	
	
	static function init(SQLWhereCol ...$params){
		
		$a = ArrayOfSQLWhereCol();
		foreach ($params as $param){
			
			$a[] = $param;	
		}
		
		return $a;
	}
	
    public function offsetSet($key, $val) {
        if ($val instanceof SQLWhereCol) {
            return parent::offsetSet($key, $val);
        }
        throw new \InvalidArgumentException('Value must be a SQLWhereCol');
    }
}

class SQLBuilder {

		
	protected $tableName = null;
	
	protected $db = null;
    
    protected $addtitionalWhereClause = null;
	  
	public function __construct($db = null, $tableName = null)
    {
        $this->db = $db;
  
        $this->tableName = $tableName;
    }

	protected function getPrimaryKeys() {
		
		
		$query = $this->db->prepare("SHOW COLUMNS FROM $this->tableName WHERE `Key` = 'PRI'");
		$query->execute();

		$col_names = $query->fetchAll(\PDO::FETCH_COLUMN);
		return $col_names;

	}
	
	protected function getColumnsDefaultValue() {
		
		
		$query = $this->db->prepare("DESCRIBE $this->tableName");
		$query->execute();

		$col_vals = $query->fetchAll(\PDO::FETCH_COLUMN, 4);

		
		return $col_vals;

	}
	
	
	protected function getColumnNames() {
		
		
		$query = $this->db->prepare("DESCRIBE $this->tableName");
		$query->execute();

		$col_names = $query->fetchAll(\PDO::FETCH_COLUMN);

		
		return $col_names;

	}
	
	
	protected function buildPKWhereClause(){
		
		$keys = $this->getPrimaryKeys();
		
		$c = count($keys);
		
		$sqlwhere = " WHERE ";
		for ($i = 0 ; $i< $c; $i++){
			
			if ($i < $c - 1){
			
			   $sqlwhere .= $keys[$i]. "=:".$keys[$i] ;
			   
			   if ($c > 1 ){
				
					$sqlwhere .= " AND " ;
			      
			   }	
			}
			else {
				
				$sqlwhere .= $keys[$i]. "=:".$keys[$i] ;
			 
			}
		
		}	
		
		return $sqlwhere;
	}
	
	
	
	public function buildInsertSql(){
		
		$col_names = $this->getColumnNames();
		
		$sql = "INSERT INTO $this->tableName (";
		
		$sql_values = " VALUES(";
		
		$c = count($col_names);
		
		for ($i = 0 ; $i< $c; $i++){
			
			$sql .= $col_names[$i];
			$sql_values .= ":".$col_names[$i];
			
			if ($i < ($c - 1)){
			
				$sql .= ",";
				$sql_values .= ",";
			}
			else {
				
				$sql .= ")";
				$sql_values .= ")";
			}	
		}
		
		$sql .= $sql_values;
		
		return $sql;	
	}
	
	
	public function buildUpdateSql(Array $inputs = null, $noIncludePK = true ){
		
		$columns = $this->getColumnNames();
        $pks = $this->getPrimaryKeys();
        
        
        
        $col_names = array();
        
        if (isset($inputs)) {
            
            $keys = array_keys($inputs);
            foreach ($keys as $key) {
                
                if (in_array($key, $columns)){
                    
                    if ($noIncludePK) {
                            
                       if (!in_array($key, $pks)){
                    
                           $col_names[] = $key;
                       }
                    }
                    else {
             
                        $col_names[] = $key;
                    }
                    
                }
                
            }
        }
        else {
            
            $col_names = $columns;
        }
        
    
		$sql = "UPDATE $this->tableName ";
		
		$sql_values = " SET ";
		
		$c = count($col_names);
		
		for ($i = 0 ; $i< $c; $i++){
			
			
			$sql_values .= $col_names[$i]."=:".$col_names[$i];
			
			if ($i < ($c - 1)){
			
				$sql_values .= ",";
			}
				
		}
		
		$sql .=  $sql_values;
		
		return $sql. $this->buildPKWhereClause();	
	}
	

	public function buildDeleteSql(){
		
		$sql = "DELETE FROM $this->tableName ";
		
		return $sql. $this->buildPKWhereClause();	
	}
	
	public function buildGetCountByPKSql(){
		
		$col_names = $this->getColumnNames();
		
		$sql = "SELECT count(*) as count FROM $this->tableName";
		
		$sql.= $this->buildPKWhereClause();	
	
		return $sql;
	}
	
	
	protected function buildWhereClause( ArrayOfSQLWhereCol $columns ){
		
		$c = count($columns);
		$whereClause = " WHERE ";
		for ($i = 0; $i < $c ; $i++ ){
			
			$whereClause .=  ($c > 1 && $i < ($c - 1)) ? $columns[$i]->name . $columns[$i]->comparator
			.":".$columns[$i]->name . " ".$columns[$i]->operator." " :  $columns[$i]->name. $columns[$i]->comparator.":".$columns[$i]->name;
			
		} 	
		
        
        if ( isset( $this->addtitionalWhereClause )){
            
            $whereClause .= $this->addtitionalWhereClause;
        
            $this->addtitionalWhereClause = null ;
        }
        
		return $whereClause ;
	}
	
    public function setAdditionalWhereClause ( $whereClause ){
        
        $this->addtitionalWhereClause = $whereClause; 
    }
    
	
	public function buildFindBySql(ArrayOfSQLWhereCol $columns,
    $orderBy = null, $limit = null , $offset = null,
    array $fieldReplacers = null , array $excludeFields = null){
		
		//print_r($columns);
		
		$col_names = $this->getColumnNames();
	
		$whereClauseCols = new ArrayOfSQLWhereCol();
		
		foreach ($columns as $col ){
				
			if (in_array($col->name, $col_names)){
			
				$whereClauseCols[] = $col;
			}
		}
		
		
		$sql = "SELECT ";
		
		$sql_fields = "";
		$c = count($col_names);
		
        $fieldReplacerKeys = [];
        
        if ( isset($fieldReplacers) ){
        
            $fieldReplacerKeys = array_keys($fieldReplacers);
        }
        
		for ($i = 0 ; $i< $c; $i++){
			
            $field_name = $col_names[$i];
            
            
            if (isset($excludeFields)){
                
                if ( !in_array($field_name, $excludeFields)){
                    
                        
                    if ( isset($fieldReplacers) && in_array($field_name, $fieldReplacerKeys)){
                        
                        $sql_fields .= $fieldReplacers[$field_name]. ' as '.$field_name  ;
                   
                    }
                    else {
                
                        $sql_fields .= $field_name ;
                    
                    }
               
                    if ($i < ($c - 1)){
                    
                        $sql_fields .= ",";
                    }

                }
                
            }
            else {
                
                    
                if ( isset($fieldReplacers) && in_array($field_name, $fieldReplacerKeys)){
                    
                    $sql_fields .= $fieldReplacers[$field_name]. ' as '.$field_name  ;
               
                }
                else {
            
                    $sql_fields .= $field_name ;
                
                }
                
                if ($i < ($c - 1)){
                
                    $sql_fields .= ",";
                }

            }
            
			
		}
		
        $sql_fields .= " FROM $this->tableName";

		$sql .= $sql_fields;
		
		
        $sql .= $this->buildWhereClause($whereClauseCols);
	
        if (isset($orderBy)) {
            
            $sql .= " ".trim($orderBy);
        }
        
        
        if (isset($limit) && is_numeric($limit)){
            
            $sql .= " LIMIT $limit";
            
            if (isset($offset) && is_numeric($offset)){
            
                $sql .= ", $offset";
            }
        }
        
        
        
       //Log::printRToErrorLog("$limit::$offset::. $sql");
        
        return $sql;
    }
	
	
	public function buildFindCountBySql(ArrayOfSQLWhereCol $columns, $asWhat = "" ){
		
		$col_names = $this->getColumnNames();
	
		$whereClauseCols = new ArrayOfSQLWhereCol();
		
		foreach ($columns as $col ){
				
			if (in_array($col->name, $col_names)){
			
				$whereClauseCols[] = $col;
			}
		}

		if ($asWhat != "") {

			$asWhat = " as $asWhat ";
		}

		$sql = "SELECT count(*) $asWhat FROM $this->tableName";

		
        $sql .= $this->buildWhereClause($whereClauseCols);
	
        
        return $sql;
	}
	

	public function buildFindByPKSql(){
		
		$col_names = $this->getColumnNames();
		
		$sql = "SELECT ";
		
		$sql_fields = "";
		$c = count($col_names);
		
		for ($i = 0 ; $i< $c; $i++){
			
			$sql_fields .= $col_names[$i];
			
			if ($i < ($c - 1)){
			
				$sql_fields .= ",";
			}
			else {
				
				$sql_fields .= " FROM $this->tableName";
			}	
		}
		
		$sql .= $sql_fields;
		
		
		return $sql. $this->buildPKWhereClause();	
	}
	
	
	public function buildFindAllSql($limit = null, $total = null ){
		
		$col_names = $this->getColumnNames();
		
		$sql = "SELECT ";
		
		$sql_fields = "";
		$c = count($col_names);
		
		for ($i = 0 ; $i< $c; $i++){
			
			
			$sql_fields .= $col_names[$i];
			
			if ($i < ($c - 1)){
			
				$sql_fields .= ",";
			}
			else {
				
				$sql_fields .= " FROM $this->tableName  ";
			}	
		}
		
		$sql .= $sql_fields;

		if ( is_numeric($limit) && !isset($total)){
			
			$sql .= " LIMIT $limit";
		}
		else
		if ( is_numeric($limit) && is_numeric($total)){
		
			$sql .= " LIMIT $limit,$total";
		
		}
		
		
		return $sql;
	}
	
	
}
?>
