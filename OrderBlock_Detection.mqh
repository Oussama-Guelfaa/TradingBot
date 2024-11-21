//+------------------------------------------------------------------+
//| Detect Imbalance and Order Block Function                        |
//+------------------------------------------------------------------+
void DetectImbalanceAndOrderBlock(int trend)
  {
   int bars = Bars(_Symbol, PERIOD_CURRENT);
   if (bars < 7)
      return; // Not enough bars

   // Get the number of digits for the symbol to calculate pip value
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pip;

   if (digits > 4)
      pip = 0.00010; // 5-digit symbols
   else if (digits == 3)
      pip = 0.01;     // 3-digit symbols (e.g., JPY pairs)
   else
      pip = 0.0001;   // 4-digit symbols

   double requiredDifference = 1.2 * pip;

   if (trend == -1) // Bearish trend
     {
      // Check for bearish imbalance (three consecutive bearish candles)
      if (IsBearishCandle(1) && IsBearishCandle(2) && IsBearishCandle(3))
        {
         // New condition: Upper wick of last red candle is at least 1.2 pips lower than lower wick of first red candle
         double high1 = iHigh(_Symbol, PERIOD_CURRENT, 1);
         double low3 = iLow(_Symbol, PERIOD_CURRENT, 3);
         double priceDifference = low3 - high1;

         if (priceDifference >= requiredDifference)
           {
            // Look back up to three candles before the imbalance for a bullish candle
            int bullishIndex = -1;
            for (int i = 4; i <= 6; i++)
              {
               if (IsBullishCandle(i))
                 {
                  bullishIndex = i;
                  break;
                 }
              }
            if (bullishIndex != -1)
              {
               // Found a bullish candle before the bearish imbalance
               double priceLevel = iOpen(_Symbol, PERIOD_CURRENT, bullishIndex);
               // Check if this order block already exists
               if (!OrderBlockExists(-1, priceLevel))
                 {
                  // Add the bearish order block
                  OrderBlock ob;
                  ob.direction = -1;
                  ob.priceLevel = priceLevel;
                  ob.timestamp = iTime(_Symbol, PERIOD_CURRENT, bullishIndex);
                  ArrayResize(orderBlocks, ArraySize(orderBlocks) + 1);
                  orderBlocks[ArraySize(orderBlocks) - 1] = ob;
                  PrintFormat("Bearish order block detected at price %.5f", priceLevel);
                 }
              }
           }
        }
     }
   else if (trend == 1) // Bullish trend
     {
      // Check for bullish imbalance (three consecutive bullish candles)
      if (IsBullishCandle(1) && IsBullishCandle(2) && IsBullishCandle(3))
        {
         // New condition: Lower wick of last green candle is at least 1.2 pips higher than upper wick of first green candle
         double low1 = iLow(_Symbol, PERIOD_CURRENT, 1);
         double high3 = iHigh(_Symbol, PERIOD_CURRENT, 3);
         double priceDifference = low1 - high3;

         if (priceDifference >= requiredDifference)
           {
            // Look back up to three candles before the imbalance for a bearish candle
            int bearishIndex = -1;
            for (int i = 4; i <= 6; i++)
              {
               if (IsBearishCandle(i))
                 {
                  bearishIndex = i;
                  break;
                 }
              }
            if (bearishIndex != -1)
              {
               // Found a bearish candle before the bullish imbalance
               double priceLevel = iOpen(_Symbol, PERIOD_CURRENT, bearishIndex);
               // Check if this order block already exists
               if (!OrderBlockExists(1, priceLevel))
                 {
                  // Add the bullish order block
                  OrderBlock ob;
                  ob.direction = 1;
                  ob.priceLevel = priceLevel;
                  ob.timestamp = iTime(_Symbol, PERIOD_CURRENT, bearishIndex);
                  ArrayResize(orderBlocks, ArraySize(orderBlocks) + 1);
                  orderBlocks[ArraySize(orderBlocks) - 1] = ob;
                  PrintFormat("Bullish order block detected at price %.5f", priceLevel);
                 }
              }
           }
        }
     }
  }
