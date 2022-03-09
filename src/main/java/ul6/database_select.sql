--1
WITH ts AS (
    SELECT block_id, COUNT(block_id) as counted
    FROM transactions
    GROUP BY block_id
    ORDER BY counted DESC
    LIMIT 10
)   SELECT *
    FROM blocks, ts
    WHERE ts.block_id = blocks.id
    ORDER BY ts.counted DESC;

--2 unixi aja kohaselt on koik tehingud tehtud 2009, nii et tegin alates 2009 aastast
SELECT hash, id,time, date_part('year', to_timestamp(time)) AS tn
    FROM blocks
    WHERE date_part('year', to_timestamp(time)) = '2009'
    ORDER BY tn DESC;--

--3
WITH inpts AS (
    SELECT tx_id, COUNT(tx_id) as count
    FROM inputs
    group by tx_id
    ORDER BY count DESC
    LIMIT 10
)   SELECT transactions.hash, transactions.id, count
    FROM transactions, inpts, blocks
    WHERE transactions.id = inpts.tx_id AND transactions.block_id = blocks.id
    ORDER BY count DESC;

--4
WITH outpts AS (
    SELECT tx_id, COUNT(tx_id) as count
    FROM outputs
    group by tx_id
    ORDER BY count DESC
    LIMIT 10
)   SELECT transactions.hash, transactions.id, count
    FROM transactions, outpts, blocks
    WHERE transactions.id = outpts.tx_id AND transactions.block_id=blocks.id
    ORDER BY count DESC;

--5
SELECT input.tx_id,  SUM(input.count + output.count) as counts
FROM
     (SELECT COUNT(inputs.tx_id) AS count, inputs.tx_id
      FROM inputs
      GROUP BY inputs.tx_id
     ) AS input,
     (SELECT COUNT(outputs.tx_id) AS count, outputs.tx_id
      FROM outputs
      GROUP BY outputs.tx_id
     ) AS output
WHERE output.tx_id = input.tx_id
GROUP BY input.tx_id
ORDER BY counts DESC;




--6
WITH trans AS (
    SELECT id, hash, block_id
    FROM transactions
    WHERE id = 9444
), inpts AS (SELECT inputs.id, inputs.tx_id, inputs.output_id
    FROM inputs, trans
    WHERE inputs.tx_id = trans.id
    GROUP BY inputs.output_id, inputs.tx_id, inputs.id)
SELECT SUM(value)
FROM inpts, outputs
WHERE inpts.output_id = outputs.id;

--7
WITH trans AS (
    SELECT id, hash, block_id
    FROM transactions
    WHERE id = 7777
) SELECT SUM(value)
  FROM trans, outputs
  WHERE trans.id = outputs.tx_id;

--8
WITH inpt AS (
    SELECT inputs.output_id
    FROM inputs
    WHERE inputs.tx_id = 7757
)
    SELECT dst_address AS address
    FROM outputs, inpt
    WHERE inpt.output_id = outputs.id
    GROUP BY dst_address;

--9
SELECT dst_address AS address
FROM outputs
WHERE outputs.tx_id = 6676
GROUP BY dst_address ;

--11
SELECT dst_address AS address, outputs.tx_id, counts
FROM outputs, (
    SELECT tx_id, count(tx_id) AS counts
    FROM inputs
    GROUP BY tx_id
    ORDER BY COUNT(tx_id) DESC
    LIMIT 10
    ) as sub
WHERE sub.tx_id = outputs.tx_id
GROUP BY dst_address, outputs.tx_id, counts
ORDER BY counts DESC


--16
SELECT transactions.id, transactions.hash, transactions.block_id
FROM transactions, (
                SELECT tx_id
                FROM outputs
                WHERE outputs.dst_address = '17abzUBJr7cnqfnxnmznn8W38s9f9EoXiq'
    ) as out
WHERE transactions.id = out.tx_id
