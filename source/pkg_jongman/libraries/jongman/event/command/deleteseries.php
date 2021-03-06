<?php
defined('_JEXEC') or die;

class RFEventCommandDeleteseries extends RFEventCommand
{
	public function __construct(RFReservationExistingseries $series)
	{
		$this->series = $series;
	}
	
	public function execute($dbo = null)
	{
		if ($dbo == null) $dbo = JFactory::getDbo();
		$query = $dbo->getQuery(true);
		$query->delete('#__jongman_reservations')
			->where('id = '.$this->series->seriesId());
		$db->setQuery($dbo);
		return $dbo->execute();
	}
}

