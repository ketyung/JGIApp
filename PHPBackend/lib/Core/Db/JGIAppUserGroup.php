<?php
namespace Core\Db;

use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Util\Log as Log;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\EncUtil as EncUtil;
use Util\StrUtil as StrUtil;

class JGIAppUserGroup extends JGIAppDbObject {
    
    public $id;
    public $name;
    public $lastUpdated;
    

    public function __construct($db)
    {
        parent::__construct($db, "jgiapp_user_group");
    }
    
}
?>
