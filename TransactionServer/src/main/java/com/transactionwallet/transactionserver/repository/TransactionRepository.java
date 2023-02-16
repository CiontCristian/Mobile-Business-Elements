package com.transactionwallet.transactionserver.repository;

import com.transactionwallet.transactionserver.model.TransactionObj;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends CrudRepository<TransactionObj, Integer> {
}
