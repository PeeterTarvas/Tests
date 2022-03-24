SELECT tootaja_id, perenimi, amet_kood, nimetus
FROM tootaja, amet
WHERE NOT EXISTS (
    SELECT *
    FROM tootamine
    WHERE tootamine.tootaja_id = tootaja.tootaja_id
    AND tootamine.amet_kood = amet.amet_kood);


SELECT COUNT(*)
FROM (
    SELECT DISTINCT perenimi
    FROM tootaja
    WHERE perenimi IS NOT NULL
    ) AS a;

CREATE TABLE new_isik(
    isikukood    VARCHAR(11)   NOT NULL,
    synniaeg     DATE          NOT NULL,
    kommentaar   TEXT NOT NULL, --TEXT = MEMO
    on_akutaalne BOOL DEFAULT TRUE,
    CONSTRAINT pk_isik PRIMARY KEY (isikukood)
);

ALTER TABLE new_isik
ADD CONSTRAINT chk_isik_isikukood
CHECK ( isikukood LIKE '[0-9]{11}');


SELECT alguse_aeg
FROM tootamine
UNION SELECT lopu_aeg
FROM tootamine;

SELECT *
FROM tootamine RIGHT JOIN  tootaja ON tootamine.tootaja_id = tootaja.tootaja_id