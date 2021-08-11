<?php
namespace Core\Db;

use Db\DbObject as DbObject;
use Core\Db\JGIAppDbObject as JGIAppDbObject;
use Core\Db\JGIAppUser as User;
use Db\SQLWhereCol as SQLWhereCol;
use Db\ArrayOfSQLWhereCol as ArrayOfSQLWhereCol;
use Util\Log as Log;
use Util\StrUtil as StrUtil;
use Util\EncUtil as EncUtil;


class JGIAppMapLegendItem extends JGIAppDbObject {
	
	public $id;
    
    public $versionNo;
    
    public $mapId;

    public $text;

    public $color;

    public $lastUpdated;
    
    
	public function __construct($db)
  {
		  parent::__construct($db, "jgiapp_map_legend_item");
  }


  public function deleteAllBy($mapId, $versionNo) {

      $sql = "DELETE from $this->tableName WHERE map_id = :map_id AND version_no=:version_no ";

      return $this->dbObject->execBySQL($sql, array('map_id'=>$mapId, 'version_no'=>$versionNo), true);
  }

}
?>