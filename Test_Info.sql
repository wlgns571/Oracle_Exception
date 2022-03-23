/*
-- 데이터베이스 구현 (4문항)
    생성 DDL, 개념
-- SQL활용 (4문항)
    DML문
-- SQL응용 (4문항)
    개념, ANSI, 분석
-- 기본적인 개념위주로
*/

/*
    유저생성 (1일차)
    CREATE USER 유저아이디 IDENTIFIED BY 비밀번호;

    권한 부여(1일차)
    GRANT 권한 TO 유저아이디(계정)

        롤 CONNECT  : 사용자가 데이터베이스에 접속 가능하도록 하기 위해서 
                      가장 기본적인 권한을 묶어 놓음
           RESOURCE : 테이블, 시퀀스, 프로시저와 같은 객체 생성 권한을 묶어 놓음
           DBA      : 전체 권한.
    
    
    권한 해제
    REVOKE 권한 FROM 유저아이디(계정명)
    
    
    객체 관련 -- 간단히 요점만 서술
    테이블(table) : 데이터베이스 객체로 관계형 데이터베이스를 구성하는 기본 데이터 구조
                   로우(행), 컬럼(열) 으로 구성된 2차원 형태(표)의 객체
                   테이블 관리를 위해 제약조건이 존재함.
                   테이블의 요소인 컬럼에는 하나의 타입과 사이즈가 존재함.
    
        CREATE TABLE 테이블명 (
            컬럼명 타입(사이즈) 제약조건 
           ,컬럼명 타입(사이즈) 제약조건 
        );
    
    뷰 (VIEW)    : 하나 이상의 테이블을 연결해 마치 테이블인 것 처럼 사용하는 객체
                   하나 이상의 테이블이나 다른 뷰의 데이터를 볼 수 있게 함.
                   실제 데이터는 뷰를 구성하는 테이블에 담겨 있음.
                    
                    복합 뷰 : 1개 이상의 테이블 (수정, 삭제, 삽입) 안됨
                            
                    단일 뷰 : 1개 테이블 (수정, 삭제, 삽입) 가능
                    
                   실제 테이블을 숨겨 보안의 목적으로 사용 가능
                   반복되는 복잡한 쿼리를 뷰로 만들어 간결하게 사용가능
    
        CREATE OR REPLACE 뷰이름 AS
        SELECT문
    
    인덱스 (INDEX) : 테이블에 있는 데이터를 빨리 찾기 위한 용도의 데이터베이스 객체
    
    시노님 (SYNONIM) : 데이터베이스 객체에 대한 별칭을 부여하는 객체
                      PUBLIC과 PRIVATE 시노님이 있음
                      PUBLIC은 모든 사용자 접근, PRIVATE는 특정 사용자 접근
    
    시퀀스 (SEQUENCE) : 일련번호 채번을 할때 사용되는 객체
                       테이블과 독립적이므로 여러 곳에서 사용가능
                       pk를 설정할 후보키가 없거나, 자동으로 순서적인 번호가 필요한 경우 사용
                       
        CREATE SEQUENCE 시퀀스 이름
        INCREMENT BY    증강숫자
        START WITH      시작숫자
        MINVALUE        최소값
        MAXVALUE        최대값; <- 이곳까지만 만들어도 됨
        NOCYCLE(CYCLE)  최대값 도달시 중지(갱신) default(nocycle)
        
        시퀀스이름.NEXTVAL 증가
        시퀀스이름.CURRVAL 현재
        
    함수 (FUNCTION) : 절차형 SQL(PL/SQL)을 활용하여 생성 할 수 있으며
                      특정 연산을 하고 값을 반환하는 객체
                      일련의 연산 처리 결과를 단일 값으로 반환
                      DBMS에서 내장함수처럼 사용자 정의 함수의 호출을 통해 실행
                      종료시 단일 값을 반환하는 것과 클라이언트에서 실행 되는 것이
                      프로시저와 다른점 (DML문에서 사용가능)
    
    프로시저 (PROCEDURE) : 업무적으로 복잡한 구문을 별도의 구문으로 작성하여 DBdp
                          저장하고 실행가능.
                          고유한 기능을 수행하는 함수와 유사하지만
                          리턴값이 0 ~ n으로 다양하게 설정가능
                          서버에서 실행되어 빠르고 안전함.
    
    패키지 (PAKAGE) : 용도에 맞게 함수나 프로시저를 하나로 묶어 놓은 객체
    
    
*/

-- DML 조작어 SELECT/INSERT/UPDATE/DELETE
SELECT *
FROM 학생
WHERE 1 = 1 -- true
AND 전공 = '경제학';

SELECT *
FROM 과목;

INSERT INTO 과목 VALUES (900, '생물학', 3);
INSERT INTO 과목 (과목번호, 과목이름, 학점)VALUES (900, '생물학', 3);
INSERT INTO 과목 (과목번호) VALUES (500);

UPDATE 과목
 SET 과목이름 = '과학'
   , 학점    = 10
WHERE 과목번호 = 900; -- where절은 대부분 key로 설정한다.

DELETE 과목
WHERE 과목번호 = 500;

-- 그룹바이 (GROUP BY)
SELECT 전공
     , AVG(평점)
FROM 학생
GROUP BY 전공
HAVING AVG(평점) > 3; -- 집계한 정보에서 검색조건을 넣을 땐 HAVING절 사용

-- 분석함수
SELECT 이름
     , 전공
     , AVG(평점) OVER (PARTITION BY 전공)
     , RANK() OVER (PARTITION BY 전공 ORDER BY 평점 DESC) 전공평점순위
FROM 학생;

-- JOIN (동등, INNER, 이퀄)
SELECT *
FROM 학생
   , 수강내역
WHERE 학생.학번 = 수강내역.학번;

-- ANSI
SELECT *
FROM 학생
INNER JOIN 수강내역
ON(학생.학번 = 수강내역.학번);

-- OUTER JOIN (외부조인)
SELECT *
FROM 학생
   , 수강내역
WHERE 학생.학번 = 수강내역.학번(+);

-- ANSI
SELECT *
FROM 학생
LEFT OUTER JOIN 수강내역
ON(학생.학번 = 수강내역.학번);

SELECT *
FROM 수강내역
RIGHT OUTER JOIN 학생
ON(학생.학번 = 수강내역.학번);

-- JOIN (동등, INNER, 이퀄)
SELECT *
FROM 학생
   , 수강내역
   , 과목
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+);

-- ANSI (조인조건 생성시 안전하게 생성가능)
SELECT *
FROM 학생
LEFT OUTER JOIN 수강내역
ON(학생.학번 = 수강내역.학번)
LEFT JOIN 과목 -- OUTER는 생략해도 가능하다.
ON(수강내역.과목번호 = 과목.과목번호);

