ALTER TABLE `isu_condition` ADD COLUMN `is_dirty` TINYINT(1) AS (CASE WHEN `condition` LIKE '%is_dirty=true%' THEN 1 ELSE 0 END) STORED;
ALTER TABLE `isu_condition` ADD COLUMN `is_overweight` TINYINT(1) AS (CASE WHEN `condition` LIKE '%is_overweight=true%' THEN 1 ELSE 0 END) STORED;
ALTER TABLE `isu_condition` ADD COLUMN `is_broken` TINYINT(1) AS (CASE WHEN `condition` LIKE '%is_broken=true%' THEN 1 ELSE 0 END) STORED;
ALTER TABLE `isu_condition` ADD COLUMN `warn_score` INT AS (`is_dirty` + `is_overweight` + `is_broken`) STORED;
CREATE INDEX `isu_condition_jia_isu_uuid` ON `isu_condition`(`jia_isu_uuid`, `warn_score`, `timestamp` DESC);
