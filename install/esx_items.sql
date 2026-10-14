INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
  ('parachute', 'Parachute', 1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);
