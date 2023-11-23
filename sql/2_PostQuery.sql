ALTER TABLE `isu_condition`
ADD COLUMN `condition_level` ENUM ('info', 'warning', 'critical') NOT NULL DEFAULT 'warning';

UPDATE `isu_condition`
SET
    `condition_level` = 'critical'
WHERE
    (
        LENGTH (`condition`) - LENGTH (REPLACE (`condition`, '=true', ''))
    ) / LENGTH ('=true') >= 3;

UPDATE `isu_condition`
SET
    `condition_level` = 'info'
WHERE
    (
        LENGTH (`condition`) - LENGTH (REPLACE (`condition`, '=true', ''))
    ) / LENGTH ('=true') = 0;

ALTER TABLE `isu_condition` ADD INDEX `isu_condition_jia_isu_uuid_idx` (
    `jia_isu_uuid`,
    `condition_level`,
    `timestamp` DESC
);

ALTER TABLE `isu` ADD INDEX `isu_jia_user_id_idx` (`jia_user_id`, `jia_isu_uuid`);
