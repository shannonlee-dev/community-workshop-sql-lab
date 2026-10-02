# MySQL 주문 데이터 분석

## JOIN과 서브쿼리 비교

Q16과 Q17은 아메리카노를 주문한 고객을 찾습니다. JOIN은 `customers → orders → order_items → menu_items` 관계를 직접 드러내므로 주문일·수량 같은 열을 추가하기 쉽습니다. 서브쿼리는 외부 쿼리를 고객에 집중시키고 `IN`으로 해당 주문의 존재를 확인합니다.

## 외래키 실패와 수정

```sql
INSERT INTO order_items (order_id, item_id, quantity, unit_price_snapshot, line_note)
VALUES (9999, 1, 1, 4500.00, 'invalid order');
```

부모 `orders`에 `order_id = 9999`가 없으면 `fk_order_items_order`가 거부해야 합니다. 부모 주문을 먼저 넣거나 존재하는 주문 ID를 사용합니다. 기존 실패 기록은 [외래키 결과](../../evidence/mysql/fk-error.txt)에 있습니다.

## 핵심 지표

1. Q18: 날짜별 주문 건수
2. Q19: 판매 수량이 많은 메뉴
3. Q20: 고객별 구매 총액

기존 쿼리 출력은 [결과 기록](../../evidence/mysql/query-results.txt), 테이블·행 수·키 제약은 [스키마 메타데이터](../../evidence/mysql/metadata.txt)에 보존합니다. 이 메타데이터에는 서버 버전·실행 시각·클라이언트 환경이 없으며 현재 서버에서 재실행한 증거가 아닙니다. 새 실행에서는 해당 환경 정보를 별도로 기록합니다.
