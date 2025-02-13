
-- SOMENTE UM TESTE

/* Conta as quantidades de pedidos por vendedor, com as datas do primeiro e do último pedido */
with comHist as (
select v.idVendedor as vendedor, count(distinct ip.idPedido) as qtde, min(p.dtPedido) as dtPrimeiroPedido, max(p.dtPedido ) as dtUltimoPedido,
datediff(DAY, dtPrimeiroPedido, dtultimoPedido) as intervalo ,  datediff(DAY, dtultimoPedido, '2018-07-02') as diasSemVenda , round((intervalo/qtde),1) as mediaDiasPraVender
from silver.olist.vendedor v
right outer join silver.olist.item_pedido ip on v.idVendedor = ip.idVendedor
join silver.olist.pedido p on ip.idPedido = p.idPedido
where p.dtPedido <= '2018-07-02'
group by   v.idVendedor
order by  qtde desc
),
semHist as 
(
  select distinct v.idVendedor as vendedor, 0 as qtde, null as dtPrimeiroPedido, null as dtUltimoPedido, null as intervalo, datediff(DAY, '2016-04-09', '2018-07-02') as diasSemVenda , 9999 as mediaDiasPraVender
                        from silver.olist.vendedor v
                        where v.idVendedor not in (select idVendedor 
                                                    from silver.olist.item_pedido ip,
                                                          silver.olist.pedido p
                                                    where p.idPedido = ip.idpedido
                                                      and   p.dtPedido <= '2018-07-02' )
)
Select c.* 
from semHist s, comHist c, silver.olist.vendedor v
where v.idVendedor = c.vendedor
union
Select s.* 
from semHist s, comHist c, silver.olist.vendedor v
where v.idVendedor = s.vendedor
