DROP TABLE IF EXISTS `isu_association_config`;
DROP TABLE IF EXISTS `isu_condition`;
DROP TABLE IF EXISTS `isu`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `isu` (
  `id` bigint AUTO_INCREMENT,
  `jia_isu_uuid` CHAR(36) NOT NULL UNIQUE,
  `name` VARCHAR(255) NOT NULL,
  `image` LONGBLOB,
  `character` VARCHAR(255),
  `jia_user_id` VARCHAR(255) NOT NULL,
  `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
   PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;

CREATE TABLE `isu_condition` (
  `id` bigint AUTO_INCREMENT,
  `jia_isu_uuid` CHAR(36) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `is_sitting` TINYINT(1) NOT NULL,
  `condition` VARCHAR(255) NOT NULL,
  `message` VARCHAR(255) NOT NULL,
  `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;

ALTER TABLE `isu_condition` ADD COLUMN `is_dirty` TINYINT(1) AS (CASE WHEN `condition` LIKE '%is_dirty=true%' THEN 1 ELSE 0 END) STORED;
ALTER TABLE `isu_condition` ADD COLUMN `is_overweight` TINYINT(1) AS (CASE WHEN `condition` LIKE '%is_overweight=true%' THEN 1 ELSE 0 END) STORED;
ALTER TABLE `isu_condition` ADD COLUMN `is_broken` TINYINT(1) AS (CASE WHEN `condition` LIKE '%is_broken=true%' THEN 1 ELSE 0 END) STORED;
ALTER TABLE `isu_condition` ADD COLUMN `warn_score` INT AS (`is_dirty` + `is_overweight` + `is_broken`) STORED;
CREATE INDEX `isu_condition_jia_isu_uuid` ON `isu_condition`(`jia_isu_uuid`, `warn_score`, `timestamp` DESC);

CREATE TABLE `user` (
  `jia_user_id` VARCHAR(255) PRIMARY KEY,
  `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;

CREATE TABLE `isu_association_config` (
  `name` VARCHAR(255) PRIMARY KEY,
  `url` VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;
