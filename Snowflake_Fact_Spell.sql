DROP TABLE IF EXISTS FACT_SPELL;

CREATE TABLE IF NOT EXISTS FACT_SPELL (
    ID_SPELL INT,
    ID_CHARACTER INT,
    ID_PLACE INT,
    ID_DIALOGUE INT,
    ID_SCENE INT,
    SPELL_FREQUENCY INT,
    INSERTED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO FACT_SPELL (
    ID_SPELL, ID_CHARACTER, ID_PLACE, ID_DIALOGUE, ID_SCENE, SPELL_FREQUENCY
)
SELECT 
    COALESCE(s.ID_SPELL, -1), 
    COALESCE(c.ID_CHARACTER, -1), 
    COALESCE(p.ID_PLACE, -1), 
    COALESCE(d."Dialogue_ID", -1), 
    COALESCE(d."Chapter_ID", -1), 
    COUNT(*) AS SPELL_FREQUENCY
FROM DIALOGUE d
INNER JOIN DIM_CHARACTER c ON d."Character_ID" = c.ID_CHARACTER
INNER JOIN DIM_PLACE p ON d."Place_ID" = p.ID_PLACE
INNER JOIN DIM_SPELL s ON LOWER(d."Dialogue") LIKE CONCAT('%', LOWER(s.INCANTATION), '%')
GROUP BY s.ID_SPELL, c.ID_CHARACTER, p.ID_PLACE, d."Dialogue_ID", d."Chapter_ID";