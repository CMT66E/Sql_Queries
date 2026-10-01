using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;

namespace ConsoleAppDateTime
{
    public class Program
    {
        public static void Main(string[] args)
        {
            string dateString, format;
            DateTime result;
            CultureInfo provider = CultureInfo.InvariantCulture;

            // Parse date-only value with invariant culture.
            dateString = "06/15/2008";
            format = "d";
            try
            {
                result = DateTime.ParseExact(dateString, format, provider);
                Console.WriteLine("{0} converts to {1}.  (MM/dd/YYYY)", dateString, result.ToString());
            }
            catch (FormatException)
            {
                Console.WriteLine("{0} is not in the correct format. A", dateString);
            }

            // Parse date-only value without leading zero in month using "d" format.
            // Should throw a FormatException because standard short date pattern of 
            // invariant culture requires two-digit month.
            dateString = "6/15/2008";
            try
            {
                result = DateTime.ParseExact(dateString, format, provider);
                Console.WriteLine("{0} converts to {1}. (MM/dd/YYYY)", dateString, result.ToString());
            }
            catch (FormatException)
            {
                Console.WriteLine("{0} is not in the correct format. B", dateString);
            }

            // Parse date and time with custom specifier.
            dateString = "Sun 15 Jun 2008 8:30 AM -06:00";
            format = "ddd dd MMM yyyy h:mm tt zzz";
            try
            {
                result = DateTime.ParseExact(dateString, format, provider);
                Console.WriteLine("{0} converts to {1}.", dateString, result.ToString());
            }
            catch (FormatException)
            {
                Console.WriteLine("{0} is not in the correct format. C", dateString);
            }

            // Parse date and time with offset but without offset's minutes.
            // Should throw a FormatException because "zzz" specifier requires leading  
            // zero in hours.
            dateString = "Sun 15 Jun 2008 8:30 AM -06";
            try
            {
                result = DateTime.ParseExact(dateString, format, provider);
                Console.WriteLine("{0} converts to {1}.", dateString, result.ToString());
            }
            catch (FormatException)
            {
                Console.WriteLine("{0} is not in the correct format. D", dateString);
            }

            dateString = "15/06/2008 08:30";
            format = "g";
            provider = new CultureInfo("fr-FR");
            try
            {
                result = DateTime.ParseExact(dateString, format, provider);
                Console.WriteLine("{0} converts to {1}. (dd/MM/YYYY)", dateString, result.ToString());
            }
            catch (FormatException)
            {
                Console.WriteLine("{0} is not in the correct format. E", dateString);
            }

            // Parse a date that includes seconds and milliseconds
            // by using the French (France) and invariant cultures.
            dateString = "18/08/2015 06:30:15.006542";
            format = "dd/MM/yyyy HH:mm:ss.ffffff";
            try
            {
                result = DateTime.ParseExact(dateString, format, provider);
                Console.WriteLine("{0} converts to {1}. (dd/MM/YYYY)", dateString, result.ToString());
            }
            catch (FormatException)
            {
                Console.WriteLine("{0} is not in the correct format. F", dateString);
            }

        }
    }
}
