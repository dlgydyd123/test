SELECT ENAME, 
		DEPTNO, 
		CASE WHEN DEPTNO =10 THEN 'New York'
			 WHEN DEPTNO = 20 THEN 'Dallas'
			 ELSE 'Unkown'
		END AS LOC_NAME
FROM EMP
WHERE JOB = 'MANAGER';

-- 직종이 'IT_PROG'인 사람들의 평균급여
SELECT  AVG(SALARY) 
FROM EMPLOYEES 
WHERE JOB_ID = 'IT_PROG';

-- CASE와 WHEN 사이에 비교하고자 하는 컬럼을 넣고
-- WHEN과 THEN 사이에 비교하고자 하는 값을 넣어서 비교하는 방법
SELECT AVG(CASE JOB_ID WHEN 'IT_PROG' THEN SALARY END)
FROM EMPLOYEES;

-- EMP 테이블에서 SAL이 3000이상이면 HIGH, 1000이상이면 MID
-- 둘다 아니면 LOW를 사원명(ENAME), 급여(SAL), 등급(GRADE)순으로 조회하세요

SELECT ENAME, SAL , CASE WHEN SAL >=3000 THEN 'HIGH'
						 WHEN SAL >=1000 THEN 'MID'
						 ELSE 'LOW'
						 END AS GRADE
FROM EMP;

-- STADIUM테이블에서 SEAT_COUNT(좌석수)가 0이상 30000이하이면 'S'
-- 30001이상 50000이하이면 'M' 다 아니면 'L'을 
-- 경기장이름 ,좌석수 , 크기순으로 조회

SELECT STADIUM_NAME, SEAT_COUNT, CASE WHEN SEAT_COUNT BETWEEN 0 AND 30000 THEN 'S' 
									  WHEN SEAT_COUNT BETWEEN 30001 AND 50000 THEN 'M'
									  ELSE 'L'
									  END AS "SIZE"
FROM STADIUM;

--PLAYER테이블에서 WEIGHT가 50이상 70이하면 'L'
-- 71이상 80이하면 'M' NULL이면 '미등록'
-- 이외에는 'H'를 선수이름 , 몸무게(단위붙이기), 크기순으로 조회

 SELECT PLAYER_NAME AS 선수이름, WEIGHT||'KG' AS 몸무게, CASE WHEN WEIGHT BETWEEN 50 AND 70 THEN 'L'
 								 						   WHEN WEIGHT BETWEEN 71 AND 80 THEN 'M'
 								  						   WHEN WEIGHT IS NULL THEN '미등록'
 								  						   ELSE 'H'
 								  						   END AS 체급
 FROM PLAYER; 
 
-- 오라클에서 콘솔로 데이터를 확인하는 법
DBMS_OUTPUT.PUT_LINE('출력할 내용');

-- 변수의 선언
DECLARE
	NAME VARCHAR2(20) := '홍길동';
	AGE NUMBER(3) := 30;
BEGIN 
	DBMS_OUTPUT.PUT_LINE('이름 : '|| NAME || CHR(10) || '나이 : '|| AGE);
END;

-- 점수에 맞는 학점 출력하기
-- 변수
-- SCORE 변수에는 80점 대입
-- GRADE
-- 당신의 점수 : XX점
-- 학점 : B
DECLARE
	SCORE NUMBER(3) :=80;
	GRADE VARCHAR2(20);
BEGIN
	IF SCORE >= 90 THEN GRADE := 'A';
	ELSIF SCORE >= 80 THEN  GRADE := 'B';
	ELSIF SCORE >= 70 THEN  GRADE := 'C';
	ELSIF SCORE >= 60 THEN  GRADE := 'D';
	ELSE GRADE := 'F';
	END IF;
	DBMS_OUTPUT.PUT_LINE('당신의 점수 : '|| SCORE ||'점' || CHR(10) || '학점 : '|| GRADE );
END;

BEGIN
	FOR i IN 1..4 LOOP
		IF MOD(i,2) = 0 THEN
			DBMS_OUTPUT.PUT_LINE(i||'는 짝수!');
		ELSE
			DBMS_OUTPUT.PUT_LINE(i||'는 홀수!');
		END IF;
	END LOOP;
END;

-- NUM1 변수 선언, 1을 대입
-- WHILE문으로 1부터 10까지의 총합을 출력하세요

DECLARE
	NUM1 NUMBER := 1;
	TOTAL NUMBER := 0;
BEGIN
	WHILE(NUM1 <= 10)
	LOOP
	TOTAL := TOTAL + NUM1;
	NUM1 := NUM1 + 1;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('총합 : ' || TOTAL);
END;

-- F(X) = 2X + 1;
-- 프로시저명 F
-- 매개변수 X
-- 출력결과 X : O, Y : O

CREATE OR REPLACE PROCEDURE F(
	X NUMBER 
)
IS
	Y NUMBER := 2*X+1;
BEGIN
	DBMS_OUTPUT.PUT_LINE('X : '|| X ||', Y : '|| Y);
END;



CREATE OR REPLACE PROCEDURE F(
	X NUMBER 
)
IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('X : '|| X ||', Y : '|| (2*X+1));
END;


CALL F(3);

SELECT * FROM JOBS;
-- JOB_ID
-- JOB_TITLE
-- MIN_SALARY
-- MAX_SALARY

-- 프로시저명 : MY_NEW_JOB_PORC
-- 호출했을 때 4개의 값을 전달받아서 JOBS에 INSERT를 할 것이다.
CREATE OR REPLACE PROCEDURE MY_NEW_JOB_PORC(
	P_JOB_ID IN JOBS.JOB_ID%TYPE,
	P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
	P_MIN_SALARY IN JOBS.MIN_SALARY%TYPE,
	P_MAX_SALARY IN JOBS.MAX_SALARY%TYPE
)
IS 
	CNT NUMBER :=0;
BEGIN 
	--1. JOBS 테이블에 매개변수로 받은 JOB_ID가 존재하는지 개수를 세는 쿼리문 작성하기
	-- 쿼리문을 통해 나온 결과를 CNT변수에 대입하겠다.
	SELECT COUNT(JOB_ID) INTO CNT FROM JOBS 
	WHERE JOB_ID = P_JOB_ID;
	--2. CNT가 0일 때는 INSERT하고, 1이면 UPDATE하기
	IF CNT = 0 THEN 
		-- INSERT문 작성하기
		INSERT INTO JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY)
		VALUES(P_JOB_ID,P_JOB_TITLE,P_MIN_SALARY,P_MAX_SALARY);
		DBMS_OUTPUT.PUT_LINE('ALL DONE ABOUT' || P_JOB_ID);
		
	ELSIF CNT = 1 THEN
		-- 데이터가 겹치게 되면 오류를 내는 것이 아니라 UPDATE를 통해 내용을 수정하자
		UPDATE JOBS SET 
		JOB_TITLE = P_JOB_TITLE, 
		MIN_SALARY = P_MIN_SALARY, 
		MAX_SALARY = P_MAX_SALARY
		WHERE JOB_ID = P_JOB_ID;
		DBMS_OUTPUT.PUT_LINE('ALL UPDATE ABOUT' || P_JOB_ID);
	END IF;
END;

-- 삭제를 하는 DEL_JOB_PROC만들기
-- JOB_ID에 들어가는 값은 매개변수를 통해 받는다.
CREATE OR REPLACE PROCEDURE DEL_JOB_PROC(
	P_JOB_ID IN JOBS.JOB_ID%TYPE
)
IS
	CNT NUMBER :=0;
BEGIN 
	SELECT COUNT(JOB_ID) INTO CNT FROM JOBS
	WHERE JOB_ID = P_JOB_ID;
	IF CNT != 0 THEN
		DELETE FROM JOBS 
		WHERE JOB_ID = P_JOB_ID;
		DBMS_OUTPUT.PUT_LINE(P_JOB_ID||'가 삭제되었습니다.');
	ELSE
	DBMS_OUTPUT.PUT_LINE('삭제할 데이터가 없습니다.');
	END IF;
END;

CALL DEL_JOB_PROC('IT');

-- 시퀀스 
-- 테이블에 값을 추가할 때 자동으로 순차적인 정수값이 들어가도록 설정해주는 객체

CREATE TABLE TBL_USER(
	IDX NUMBER PRIMARY KEY,
	NAME VARCHAR2(50)
)

-- 시퀀스 생성하기
-- CREATE SEQUENCE 시퀀스명;

CREATE SEQUENCE SEQ_USER; 

INSERT INTO TBL_USER VALUES (SEQ_USER.NEXTVAL,'홍길동');
INSERT INTO TBL_USER VALUES (SEQ_USER.NEXTVAL,'김길동');
INSERT INTO TBL_USER VALUES (SEQ_USER.NEXTVAL,'이길동');
INSERT INTO TBL_USER VALUES (SEQ_USER.NEXTVAL,'박길동');
INSERT INTO TBL_USER VALUES (SEQ_USER.NEXTVAL,'조길동');



SELECT * FROM TBL_USER;



CALL MY_NEW_JOB_PORC('IT', 'Developer', 7000, 15000);

SELECT *FROM JOBS;



-- 시퀀스명.CURRVAL
-- 현재 시퀀스 객체에 들어있는 값으 반환
SELECT SEQ_USER.NEXTVAL FROM DUAL;
SELECT SEQ_USER.CURRVAL FROM DUAL;

-- 시퀀스 값 초기화 하는 방법
-- 가장 좋은 방법은 지웠다가 다시 만들기
-- 대부분은 권한이 없기 때문에 삭제할 수 없다.

-- 1. 현재 시퀀스의 값을 확인
-- 2. 현재 시퀀스 값 만큼 INCREAMENT를 뺀다.
-- 현재 시퀀스의 증가량을 -로 바꾸기
ALTER SEQUENCE SEQ_USER INCREMENT BY -21;

-- 3. NEXTVAL을 한번 한다.
-- 증가량만큼 변화
SELECT SEQ_USER.NEXTVAL FROM DUAL;

-- 4. 증가량을 다시 1로 바꿔 놓는다.
ALTER SEQUENCE SEQ_USER INCREMENT BY 1;

SELECT SEQ_USER.NEXTVAL FROM DUAL;


-- 시퀀스 삭제하기
-- DROP SEQUENCE 시퀀스명;



