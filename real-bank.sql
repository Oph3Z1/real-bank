CREATE TABLE IF NOT EXISTS `real_bank` (
  `identifier` varchar(50) DEFAULT NULL,
  `info` longtext DEFAULT NULL,
  `credit` longtext DEFAULT NULL,
  `transaction` longtext DEFAULT NULL,
  `iban` int(4) DEFAULT NULL,
  `password` int(8) DEFAULT NULL,
  `AccountUsed` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
