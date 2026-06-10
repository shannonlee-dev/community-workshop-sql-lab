# Bonus Notes

Requirement IDs: BONUS-001, BONUS-002, BONUS-003

Evidence references: `runtime/done_logs/BONUS-001.log`, `runtime/blocked.log`, `runtime/done_logs/BONUS-003.log`

## JOIN And Subquery Comparison

Q16 and Q17 answer the same question: which customers ordered Americano.

The JOIN version exposes the relationship path directly across `customers`, `orders`, `order_items`, and `menu_items`, so it is easier to extend with order dates or quantities. The subquery version keeps the outer query focused on customers and hides the relationship lookup inside `IN (...)`, which can be easier to read for a membership-style condition.

## FK Error And Fix

Intentional failing SQL:

```sql
INSERT INTO order_items (order_id, item_id, quantity, unit_price_snapshot, line_note)
VALUES (9999, 1, 1, 4500.00, 'invalid order');
```

Expected reason: `order_id = 9999` does not exist in the parent `orders` table, so `fk_order_items_order` must reject the row.

Fix: insert the parent order first, or change the child row to reference an existing `orders.order_id`.

## Three Core Metrics

1. Daily order count trend: Q18 groups orders by date.
2. Top menu items by sold quantity: Q19 sums order item quantities by menu item.
3. Customer purchase totals: Q20 sums order line amounts by customer.
