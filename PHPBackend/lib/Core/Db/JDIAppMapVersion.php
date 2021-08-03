<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JDIAppDbObject as JDIAppDbObject;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;

class JDIAppMapVersion extends JDIAppDbObject {
	
	public $id;
    
    public $versionNo;
    
    public $status;

    public $createdBy;
     
    public $lastUpdated;
    
    
	public function __construct($db)
    {
		parent::__construct($db, "jdiapp_map_version");
    }


    /// default first 50, will modify later
    public function findByUserId($uid, $limit = 0, $offset = 50){
    
        $a = new ArrayOfSQLWhereCol();
        $a[] = new SQLWhereCol("created_by", "=", "", $uid);

        $res = $this->findByWhere($a, true, " ORDER BY last_updated DESC", $limit, $offset);
        
        return $res;
    }
    
}
?>