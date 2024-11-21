//+------------------------------------------------------------------+
//| Order_Management.mqh                                             |
//+------------------------------------------------------------------+
//| Contains functions for order placement and management            |
//+------------------------------------------------------------------+

void PlaceOrder(ENUM_ORDER_TYPE orderType)
{
   MqlTradeRequest request;
   MqlTradeResult  result;

   ZeroMemory(request);
   ZeroMemory(result);

   // Get the number of digits for the symbol to define the pip value
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pip = (digits == 5 || digits == 3) ? 0.00010 : 0.0001;

   double entryPrice;
   double stopLossPrice;
   double takeProfitPrice;

   if (orderType == ORDER_TYPE_BUY)
   {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      entryPrice = ask;

      stopLossPrice = ask - (StopLossPips * pip);
      takeProfitPrice = ask + (TakeProfitPips * pip);
   }
   else if (orderType == ORDER_TYPE_SELL)
   {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      entryPrice = bid;

      stopLossPrice = bid + (StopLossPips * pip);
      takeProfitPrice = bid - (TakeProfitPips * pip);
   }
   else
   {
      Print("Invalid order type");
      return;
   }

   // Check the minimum required distance for stops
   double stopLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * pip;
   if (MathAbs(entryPrice - stopLossPrice) < stopLevel || MathAbs(entryPrice - takeProfitPrice) < stopLevel)
   {
      PrintFormat("Invalid stops: SL or TP too close to the price (StopLevel: %.5f)", stopLevel);
      return;
   }

   // Normalize prices to match the number of decimals
   stopLossPrice = NormalizeDouble(stopLossPrice, digits);
   takeProfitPrice = NormalizeDouble(takeProfitPrice, digits);

   // Fill the trade request structure
   request.action      = TRADE_ACTION_DEAL;
   request.symbol      = _Symbol;
   request.volume      = LotSize;
   request.type        = orderType;
   request.price       = entryPrice;
   request.sl          = stopLossPrice;
   request.tp          = takeProfitPrice;
   request.type_filling = ORDER_FILLING_IOC;
   request.type_time    = ORDER_TIME_GTC;

   // Send the trade request
   if (!OrderSend(request, result))
   {
      PrintFormat("OrderSend failed with error %d", GetLastError());
   }
   else
   {
      PrintFormat("Order placed successfully. Ticket: %d | Type: %s | SL: %.5f | TP: %.5f",
                  result.order,
                  (orderType == ORDER_TYPE_BUY) ? "BUY" : "SELL",
                  stopLossPrice,
                  takeProfitPrice);
   }
}
