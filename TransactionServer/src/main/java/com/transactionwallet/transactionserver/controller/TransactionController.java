package com.transactionwallet.transactionserver.controller;

import com.transactionwallet.transactionserver.model.TransactionObj;
import com.transactionwallet.transactionserver.repository.TransactionRepository;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/wallet")
@Slf4j
public class TransactionController {
    private final TransactionRepository transactionRepository;

    @Autowired
    public TransactionController(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    @GetMapping(value = "/findAll")
    ResponseEntity<List<TransactionObj>> findAll(){
        return new ResponseEntity<>((List<TransactionObj>) transactionRepository.findAll(), HttpStatus.OK);
    }

    @PostMapping(value = "/insertTransaction")
    ResponseEntity<TransactionObj> insertTransaction(@RequestBody TransactionObj transaction){
        log.info("In insertTransaction: tran={}", transaction);
        transactionRepository.save(transaction);

        return new ResponseEntity<>(transaction, HttpStatus.OK);
    }

    @DeleteMapping(value = "/deleteTransaction/{id}")
    ResponseEntity<?> deleteTransaction(@PathVariable int id){
        log.info("In deleteTransaction: id={}", id);
        transactionRepository.deleteById(id);

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
