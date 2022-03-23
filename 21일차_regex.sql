SELECT mem_hometel
from member
where regexp_like(mem_hometel, '^[0-9]{2}-[0-9]{3}-');


-- mem_pass가 7로 끝나는 경우
select *
from member
where REGEXP_like(mem_pass,'7$');

-- mem_add2 주소 컬럼의 데이터가
-- 숫자 공백 숫자 형태 or 한글 공백 숫자 형태인 데이터를 출력하시오
-- | <- or의미
select mem_add2
from member
where REGEXP_like(mem_add2,'[0-9][ ][0-9]|[가-힟][ ][0-9]');

-- 한글이 없는 주소만 출력하시오
select mem_add2
from member
where not REGEXP_like(mem_add2,'[가-힟]');

select mem_add2
from member
where REGEXP_like(mem_add2,'[0-9]*[^가-힟]*-+');


select mem_add2
from member
where REGEXP_like(mem_add2,'^[0-9\-]*$');

-- REGEXP_SUBSTR
select REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 1) as mem_id
     , REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 2) as mem_domain
     , mem_mail
     , REGEXP_SUBSTR('A-01-02', '[^-]+', 1, 1) as a1
     , REGEXP_SUBSTR('A-01-02', '[^-]+', 1, 2) as a2
     , REGEXP_SUBSTR('A-01-02', '[^-]+', 1, 3) as a3
     , REGEXP_SUBSTR('A-01-02', '[^-]+', 1, 4) as a4
from member;

select REGEXP_SUBSTR(mem_add1, '[^ ]*')
     , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 2)
     , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 3)
     , mem_add1
from member;

-- REGEXP_REPLACE
select REGEXP_REPLACE('안녕     하세요      반갑습니다', '[ ]{2,}', ' ') as 공백제거
     , REPLACE('안녕     하세요      반갑습니다', '  ', ' ') as 공백제거 -- 제대로 실행되지 않음
     , REGEXP_REPLACE('1234567891239', '[0-9]', '*', 7)
     , REGEXP_REPLACE('Joe     Smith LEE', '(.*) (.*) (.*)', '\3, \2 \1') as 치환
from dual;

-- Member 테이블의 mem_add1 컬럼에서 대전 주소만 대전(공백)다음주소로 나오게 출력
select mem_add1
     , REGEXP_REPLACE(mem_add1, '^[대전][가-힟]{1,}', '대전') as result
from member
where mem_add1 like '대전%'
and mem_id not in 'p001';