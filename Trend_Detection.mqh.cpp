//+------------------------------------------------------------------+
//| Trend_Detection.mqh                                              |
//+------------------------------------------------------------------+
//| Contains functions to determine market trend                     |
//+------------------------------------------------------------------+

int GetTrend()
{
   if (ArraySize(FastEMA) < 2 || ArraySize(SlowEMA) < 2)
      return 0; // Not enough data

   if (FastEMA[1] > SlowEMA[1])
      return 1; // Bullish trend
   else if (FastEMA[1] < SlowEMA[1])
      return -1; // Bearish trend
   else
      return 0; // No trend
}