ALTER TABLE `isu_condition`
ADD COLUMN `condition_level` ENUM ('info', 'warning', 'critical') AS (
    CASE
        WHEN (
            (
                LENGTH (`condition`) - LENGTH (REPLACE (`condition`, '=true', ''))
            ) / LENGTH ('=true')
        ) >= 3 THEN 'critical'
        WHEN (
            (
                LENGTH (`condition`) - LENGTH (REPLACE (`condition`, '=true', ''))
            ) / LENGTH ('=true')
        ) >= 1 THEN 'warning'
        ELSE 'info'
    END
) STORED;

ALTER TABLE `isu_condition` ADD INDEX `isu_condition_jia_isu_uuid_idx` (
    `jia_isu_uuid`,
    `condition_level`,
    `timestamp` DESC
);

ALTER TABLE `isu` ADD INDEX `isu_jia_user_id_idx` (`jia_user_id`);
