-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_layouts`
--

CREATE TABLE IF NOT EXISTS `#__jongman_layouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `alias` varchar(200) NOT NULL,
  `timezone` varchar(100) NOT NULL,
  `published` tinyint(4) NOT NULL DEFAULT '1',
  `note` varchar(200) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL,
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `access` int(11) NOT NULL DEFAULT '1',
  `language` varchar(10) NOT NULL DEFAULT '*',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_quotas`
--

CREATE TABLE IF NOT EXISTS `#__jongman_quotas` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `alias` varchar(200) NOT NULL,
  `quota_limit` decimal(7,2) unsigned NOT NULL,
  `unit` varchar(25) NOT NULL,
  `duration` varchar(25) NOT NULL,
  `schedule_id` smallint(5) unsigned DEFAULT NULL,
  `resource_id` smallint(5) unsigned DEFAULT NULL,
  `group_id` smallint(5) unsigned DEFAULT NULL,
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_user_id` int(11) NOT NULL DEFAULT '0',
  `created_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_user_id` int(11) NOT NULL DEFAULT '0',
  `modified_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `published` tinyint(4) NOT NULL DEFAULT '1',
  `access` int(11) NOT NULL,
  `note` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `resource_id` (`resource_id`),
  KEY `group_id` (`group_id`),
  KEY `schedule_id` (`schedule_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_reservations`
--

CREATE TABLE IF NOT EXISTS `#__jongman_reservations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `alias` varchar(50) NOT NULL,
  `repeat_type` varchar(10) NOT NULL,
  `repeat_options` text NOT NULL,
  `created_by` int(11) unsigned NOT NULL COMMENT 'reserved by (user id)',
  `created` datetime NOT NULL COMMENT 'change from created',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0',
  `modified` datetime DEFAULT '0000-00-00 00:00:00',
  `type_id` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1=reservation,2=black out',
  `state` smallint(6) NOT NULL DEFAULT '1' COMMENT 'changed from is_pending;1=approved, -1=pending',
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `access` int(11) NOT NULL DEFAULT '0',
  `note` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `res_created` (`created`),
  KEY `res_modified` (`modified`),
  KEY `reservations_pending` (`state`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Store reservation series' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_reservation_instances`
--

CREATE TABLE IF NOT EXISTS `#__jongman_reservation_instances` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reference_number` varchar(20) NOT NULL,
  `reservation_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='one reservation has more than one instance if its repeat option is not none.' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_reservation_resources`
--

CREATE TABLE IF NOT EXISTS `#__jongman_reservation_resources` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reservation_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `resource_level` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_id` (`reservation_id`,`resource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='multiple resources per reservation' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_reservation_users`
--

CREATE TABLE IF NOT EXISTS `#__jongman_reservation_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_level` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_id` (`reservation_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Users in each reservation, owner=1 implies reservation owner' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_resources`
--

CREATE TABLE IF NOT EXISTS `#__jongman_resources` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) NOT NULL,
  `title` varchar(128) NOT NULL,
  `description` text NOT NULL,
  `image` varchar(200) NOT NULL,
  `alias` varchar(128) NOT NULL,
  `location` varchar(250) DEFAULT NULL,
  `contact_info` varchar(200) NOT NULL,
  `note` varchar(200) NOT NULL,
  `rphone` varchar(16) DEFAULT NULL COMMENT 'deprecated',
  `notes` text COMMENT 'deprecated',
  `params` mediumtext NOT NULL,
--  `min_reservation` int(11) NOT NULL COMMENT 'Minimum reservation length for this resource',
--  `max_reservation` int(11) NOT NULL COMMENT 'Maximum reservation length for this resource',
--  `auto_assign` smallint(6) DEFAULT '0',
--  `need_approval` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'Need admin approval or not',
--  `allow_multi` smallint(6) DEFAULT '1' COMMENT 'Allow multiple day reservation (not same as recur. )',
--  `max_participants` int(11) DEFAULT '0',
--  `min_notice_duration` int(11) NOT NULL DEFAULT '0' COMMENT 'hours prior to start time',
--  `max_notice_duration` int(11) NOT NULL DEFAULT '0' COMMENT 'hours from current time',
  `asset_id` int(11) NOT NULL,
  `access` int(11) NOT NULL DEFAULT '0',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `published` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `created_on` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified_on` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `rs_scheduleid` (`schedule_id`),
  KEY `rs_name` (`title`),
  KEY `rs_status` (`status`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_schedules`
--

CREATE TABLE IF NOT EXISTS `#__jongman_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `day_start` int(11) NOT NULL DEFAULT '480' COMMENT 'time start, default = 8:00',
  `day_end` int(11) NOT NULL DEFAULT '1200' COMMENT 'time end for reservation, default=20:00',
  `time_span` smallint(3) DEFAULT NULL,
  `time_format` tinyint(4) NOT NULL DEFAULT '24' COMMENT 'time format to show in calendar (12/24)',
  `layout_id` int(9) NOT NULL,
  `view_days` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'number of days to show (1-7)',
  `weekday_start` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Start day in calendar, 0=sunday, 1=monday..',
  `show_summary` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'Show summary text for this schedule',
  `summary_required` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Is Summary field required user input',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `params` mediumtext NOT NULL,
  `ordering` int(11) NOT NULL,
  `access` int(11) NOT NULL,
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `admin_email` varchar(100) NOT NULL,
  `notify_admin` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'Notify admin on reservation made or change',
  `published` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `#__jongman_time_blocks`
--

CREATE TABLE IF NOT EXISTS `#__jongman_time_blocks` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(85) DEFAULT NULL,
  `end_label` varchar(85) DEFAULT NULL,
  `availability_code` tinyint(2) unsigned NOT NULL,
  `layout_id` mediumint(8) unsigned NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `day_of_week` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `layout_id` (`layout_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
