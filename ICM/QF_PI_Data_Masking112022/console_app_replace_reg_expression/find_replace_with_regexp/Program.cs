using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace find_replace_with_regexp
{
    class Program
    {
        static void Main(string[] args)
        {
            string rootfolder = @"C:\Users\eric.he\Desktop\current_task\ChangiAirportPrivateInfoRemove\original_docs\Biometris_Log";
            foreach (string dirFile in Directory.GetDirectories(rootfolder))
            {
                Console.WriteLine("Sub directory name: {0}", dirFile.ToString());
            }

            Regex regex = new Regex("(?i)[EK][0-9]{7}[A-Z](?-i)");
            string[] files = Directory.GetFiles(rootfolder, "*.*", SearchOption.AllDirectories);
            foreach (string file in files)
            {
                
                try
                {
                    Console.WriteLine("read file name: {0}", file.ToString());
                    string contents = File.ReadAllText(file);
                    contents = regex.Replace(contents, "xxxxxxxx");
                    // Make files writable
                    File.SetAttributes(file, FileAttributes.Normal);
                    File.WriteAllText(file, contents);
                    Console.WriteLine("close file name: {0}", file.ToString());
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }

            Console.WriteLine();
        }
    }
}
