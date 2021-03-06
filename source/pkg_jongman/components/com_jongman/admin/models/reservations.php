<?php
jimport('joomla.application.component.modellist');

/**
 * reservation model.
 *
 * @package     JONGman
 * @subpackage  Administrator
 * @since       1.0
 */
class JongmanModelReservations extends JModelList
{
	/**
	 * Method to auto-populate the model state.
	 *
	 * Note. Calling getState in this method will result in recursion.
	 
	 * @param   string  $ordering   An optional ordering field.
	 * @param   string  $direction  An optional direction (asc|desc).
	 *
	 * @return  void
	 * @since   1.0
	 */
	protected function populateState($ordering = 'r.title', $direction = 'asc')
	{
		// Initialise variables.
		$app = JFactory::getApplication('administrator');

		// Load the filter state.
		$search = $this->getUserStateFromRequest($this->context.'.filter.search', 'filter_search');
		$this->setState('filter.search', $search);

		$accessId = $this->getUserStateFromRequest($this->context.'.filter.access', 'filter_access', null, 'int');
		$this->setState('filter.access', $accessId);

		$published = $this->getUserStateFromRequest($this->context.'.filter.state', 'filter_published', '', 'string');
		$this->setState('filter.state', $published);

		$scheduleId = $this->getUserStateFromRequest($this->context.'.filter.schedule_id', 'filter_schedule_id', null, 'int');
		$this->setState('filter.schedule_id', $scheduleId);
		
		$resourceId = $this->getUserStateFromRequest($this->context.'.filter.resource_id', 'filter_resource_id', null, 'int');
		$this->setState('filter.resource_id', $resourceId);
		
		$reservationType = $this->getUserStateFromRequest($this->context.'.filter.reservation_type', 'filter_reservation_type', null, 'int');
		$this->setState('filter.reservation_type', $reservationType);
		
		// Load the parameters.
		$params = JComponentHelper::getParams('com_jongman');
		$this->setState('params', $params);		
		// Set list state ordering defaults.
		parent::populateState($ordering, $direction);
	}

	/**
	 * Build an SQL query to load the list data.
	 *
	 * @return  JDatabaseQuery
	 * @since   1.0
	 */
	protected function getListQuery()
	{
		// Initialise variables.
		$db		= $this->getDbo();
		$query	= $db->getQuery(true);

		// Select the required fields from the table.
		$query->select(
			$this->getState(
				'list.select', 
				'a.id, a.start_date, a.end_date, a.reference_number, a.reservation_id')
		);
		$query->from('#__jongman_reservation_instances AS a');
		
		$query->select('r.alias as alias, r.title as title, ' .
			'r.checked_out, r.checked_out_time, ' .
			'r.state, r.access, r.created');
		$query->join('INNER','#__jongman_reservations AS r ON r.id=a.reservation_id');
		
		// Join over the users for the checked out user.
		$query->select('uc.name AS editor');
		$query->join('LEFT', '#__users AS uc ON uc.id=r.checked_out');
		
		$query->select('o.user_id as owner_id, o.user_level');
		$query->join('LEFT', '#__jongman_reservation_users AS o ON o.reservation_id=a.reservation_id');
		
		// Join over the users for the owner user.
		$query->select('own.name AS owner');
		$query->join('LEFT', '#__users AS own ON own.id=o.user_id');

		// Join over the asset groups.
		$query->select('ag.title AS access_level');
		$query->join('LEFT', '#__viewlevels AS ag ON ag.id=r.access');

		// Join over the schedules.
		$query->select('sc.name AS schedule_title');
		$query->join('LEFT', '#__jongman_schedules AS sc ON sc.id=r.schedule_id');
				
		// Join over the users for the author.
		$query->select('au.name AS author');
		$query->join('LEFT', '#__users AS au ON au.id=r.created_by');
		
		if ($reservationType = $this->getState('filter.reservation_type')) {
			$query->where('r.type_id ='.(int)$reservationType);
		}
		
		if ($scheduleId = $this->getState('filter.schedule_id')) {
			$query->where('r.schedule_id='.(int)$scheduleId);	
		}
		
		$query->where('o.user_level=1');
		
		if ($access = $this->getState('filter.access')) {
			$query->where('r.access = '.$access);
		}
		
		if ($resourceId = $this->getState('filter.resource_id')) {
			$query->where('a.reservation_id IN 
				(SELECT reservation_id FROM #__jongman_reservation_resources WHERE resource_id='.(int)$resourceId.')');
		}
		
		// Add the list ordering clause.
		$orderCol	= $this->state->get('list.ordering');
		$orderDirn	= $this->state->get('list.direction');

		$query->order($db->getEscaped($orderCol.' '.$orderDirn));

		return $query;
	}
	
	public function getItems()
	{
		$items = parent::getItems();
		if ($items === false) return false;
		$dbo = $this->getDbo();
		$query = $dbo->getQuery(true);
		foreach($items as $i => $item) {
			$query->clear();
			$query->select('r.title as resource_name')
				->from('#__jongman_reservation_resources AS a')
				->join('LEFT','#__jongman_resources AS r on r.id=a.resource_id')
				->where('reservation_id = '.(int)$item->reservation_id);
			$dbo->setQuery($query);
			$items[$i]->resources = implode(',', $dbo->loadColumn());
		}
		
		return $items;
	}
	
}