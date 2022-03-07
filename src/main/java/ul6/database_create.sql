CREATE TABLE IF NOT EXISTS blocks (
    id BIGINT,
    hash VARCHAR(100),
    time BIGINT
);

CREATE TABLE IF NOT EXISTS transactions (
    id BIGINT,
    hash VARCHAR(100),
    block_id BIGINT
);

CREATE TABLE IF NOT EXISTS outputs (
    id BIGINT,
    dst_address VARCHAR(100),
    value BIGINT,
    tx_id BIGINT,
    off_set SMALLINT
);

CREATE TABLE IF NOT EXISTS inputs (
    id BIGINT,
    output_id BIGINT,
    tx_id BIGINT,
    off_set SMALLINT
);

COPY blocks(id, hash, time)
FROM '/home/peeter/IdeaProjects/Tests/src/main/resources/bitcoin_blockchain_10000_CSV/blocks.csv'
DELIMITER ';'
CSV HEADER;

COPY transactions(id, hash, block_id)
FROM '/home/peeter/IdeaProjects/Tests/src/main/resources/bitcoin_blockchain_10000_CSV/transactions.csv'
DELIMITER ';'
CSV HEADER;

COPY outputs(id, dst_address, value, tx_id, off_set)
FROM '/home/peeter/IdeaProjects/Tests/src/main/resources/bitcoin_blockchain_10000_CSV/outputs.csv'
DELIMITER ';'
CSV HEADER;

COPY inputs(id, output_id, tx_id, off_set)
FROM '/home/peeter/IdeaProjects/Tests/src/main/resources/bitcoin_blockchain_10000_CSV/inputs.csv'
DELIMITER ';'
CSV HEADER;