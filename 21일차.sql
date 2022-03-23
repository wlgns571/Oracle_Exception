CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- (1) 잘못된 부서번호일 경우 예외 정의
BEGIN
     -- 부서테이블에서 해당 부서번호 존재유무 체크
     SELECT COUNT(*)
       INTO vn_cnt
       FROM departments
      WHERE department_id = p_department_id;
     IF vn_cnt = 0 THEN
        RAISE ex_invalid_depid; -- (2) 사용자 정의 예외 발생
     END IF;
     -- employee_id의 max 값에 +1
     SELECT MAX(employee_id) + 1
       INTO vn_employee_id
       FROM employees; 
     -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
   COMMIT;        
      
EXCEPTION WHEN ex_invalid_depid THEN --(3) 사용자 정의 예외 처리구간 
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              
END;                	

EXEC ch10_ins_emp_proc ('홍길동', 999);

select *
from employees;

/* SAVEPOINT
   작업 전체를 취소하는 것이 아니라 특정 부분에서 트랜잭션을 취소
   취소하려는 지점 설정 뒤 그 지점까지만 작업 취소
*/
CREATE TABLE ex9_1 (
    ex_no number
  , ex_nm varchar2(100)
);

CREATE OR REPLACE PROCEDURE save_point_porc(flag varchar2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    point3 EXCEPTION;
    vn_num number;
BEGIN
    INSERT INTO ex9_1 VALUES (1, 'POINT1');
    SAVEPOINT savepoint1;
    
    INSERT INTO ex9_1 VALUES (2, 'POINT2');
    SAVEPOINT savepoint2;

    INSERT INTO ex9_1 VALUES (3, 'END');
    
    -- 3일때 rollback
    -- 다른 수 일때 정상 commit;
    
    IF flag = '1' THEN
     RAISE point1;
    ELSIF flag = '2' THEN
     RAISE point2;
    ELSIF flag = '3' THEN
     RAISE point3;
    ELSE
     vn_num := 10 / 0;
    END IF;
    
    COMMIT;
    
EXCEPTION 
    WHEN point1 THEN
      DBMS_OUTPUT.PUT_LINE('point1');
     ROLLBACK TO savepoint1;
     COMMIT;
    WHEN point2 THEN
      DBMS_OUTPUT.PUT_LINE('point2');
     ROLLBACK TO savepoint2;
     COMMIT;
    WHEN point3 THEN
      DBMS_OUTPUT.PUT_LINE('rollback');
     ROLLBACK;
     COMMIT;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('all');
     COMMIT;
END;

exec save_point_porc('4');

delete ex9_1;
commit;
select *
from ex9_1;
