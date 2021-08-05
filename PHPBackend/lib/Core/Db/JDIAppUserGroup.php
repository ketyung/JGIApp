<?php
namespace Core\Db;

use Core\Db\JDIAppDbObject as JDIAppDbObject;
use Util\Log as Log;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\EncUtil as EncUtil;
use Util\StrUtil as StrUtil;

class JDIAppUserGroup extends JDIAppDbObject {
    
    public $id;
    public $name;
    public $lastUpdated;
    

    public function __construct($db)
    {
        parent::__construct($db, "jdiapp_user_group");
    }
    
}
?>
