//+------------------------------------------------------------------+
//| Utility_Functions.mqh                                            |
//+------------------------------------------------------------------+
//| Contains utility functions                                       |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Check if an order block already exists                           |
//+------------------------------------------------------------------+
bool OrderBlockExists(int direction, double priceLevel)
  {
   for (int i = 0; i < ArraySize(orderBlocks); i++)
     {
      if (orderBlocks[i].direction == direction && MathAbs(orderBlocks[i].priceLevel - priceLevel) < 1e-5)
        {
         return true;
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
//| Check if candle is bullish                                       |
//+------------------------------------------------------------------+
bool IsBullishCandle(int index)
  {
   double open = iOpen(_Symbol, PERIOD_CURRENT, index);
   double close = iClose(_Symbol, PERIOD_CURRENT, index);
   return (close > open);
  }

//+------------------------------------------------------------------+
//| Check if candle is bearish                                       |
//+------------------------------------------------------------------+
bool IsBearishCandle(int index)
  {
   double open = iOpen(_Symbol, PERIOD_CURRENT, index);
   double close = iClose(_Symbol, PERIOD_CURRENT, index);
   return (close < open);
  }

//+------------------------------------------------------------------+
//| Count Open Trades by Symbol Function                             |
//+------------------------------------------------------------------+
int CountOpenTradesBySymbol()
  {
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(PositionGetSymbol(i) == _Symbol)
        {
         count++;
        }
     }
   return count;
  }