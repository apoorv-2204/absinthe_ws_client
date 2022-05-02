defmodule AbsintheWsClient do
  @moduledoc """
  Documentation for `AbsintheWsClient`.
  """
  require Logger
  alias ArchEthic.Utils.WSClient
  alias ArchEthic.Utils.WebSocket.PID_SubscriptionServer
  alias ArchEthic.Utils.WebSocket.PID_WebSocketHandler

  def go() do
    ws_clients =
      Enum.map(1..80, fn _x ->
          {ss_pid1, ws_pid1} = get_client()
          GenServer.cast(ws_pid1, {:join})
          {ss_pid1, ws_pid1}
      end)

    IO.inspect(ws_clients)
    Process.sleep(10_000)

    # task_res =
    #   Enum.map(get_txn_addr(), fn x ->
    #     Task.async(fn ->
    #       {ss, ws} = Enum.random(ws_clients)
    #       await_replication(x, ss)
    #     end)
    #   end)
    #   |> Enum.map(fn data ->
    #     IO.inspect(data)
    #     Task.await(data, 1000)
    #   end)

    task_res =
      Enum.map(get_txn_addr(), fn x ->
        Task.async(fn ->
          IO.inspect(Enum.random(ws_clients), label: "random")
          {ss, ws} = Enum.random(ws_clients)
          await_replication(x, ss)
        end)
      end)
      |> Enum.map(fn data ->
        IO.inspect(data)
        Task.await(data, 15_000)
      end)
  end

  def get_client() do
    ss_pid1 = PID_SubscriptionServer.start(ss_name: random_non_colliding_int()) |> elem(1)

    ws_pid1 =
      PID_WebSocketHandler.start(
        host: "localhost",
        port: 4000,
        ss_pid: ss_pid1,
        ws_name: random_non_colliding_int()
      )
      |> elem(1)

    PID_SubscriptionServer.set_state(ss_pid1, ws_pid1)
    Logger.debug("Binding #{inspect(binding())}")
    {ss_pid1, ws_pid1}
  end

  def random_non_colliding_int(),
    do:
      System.unique_integer([:monotonic])
      |> Integer.to_string()
      |> String.to_atom()

  def main() do
    # ArchEthic.Utils.WSClient.start_ws_client(host: "localhost", port: 4000)
    # await_replication("0000B61478BBFA17EDD202B16F33B3761BDE850D5D75751C6112F04C8E16AFC53063")
    # txn_addr_list =  Enum.shuffle(get_txn_addr)
    #   Task.async_stream(txn_addr_list, fn x ->
    #     await_replication(x)
    # end)|>Stream.run()

    #   Process.sleep(100)
    #   Task.async_stream(1..100, fn x -> IO.inspect(x)
    #     Task.async_stream(get_data(), fn x ->
    #       await_replication(x)
    #     end)|>Stream.run()
    # end)|>Stream.run()
  end

  def get_txn_addr() do
    [
      "000068A9CC4F77F39C3CAAB4B38302B1ED61117BFD6F937FF9892599F5C78E893B4D",
      "0000310139FF0504FABD5F61968FC234E6F73907E4C10F265854734032885F4FDEF5",
      "00008D6D0FD165FEF6966E4E6ACE0DDF2A9CA4E24F5ADBFF5CFB370B477A058DB769",
      "0000B632541B4623125CAADBA981ABCF455D7B43FE47945EA06BC2266E21B6C52A07",
      "000099464CB82269E3AFC94268D199F2304E73F4023A07C343D218959A29C765720E",
      "000090219B368F323842661AF9C2A857619268459D65B14864AEE040E815666891A5",
      "00003BAF97AC76389B773897540314EA6DA4C3C765E99F612ADE756EBAD3EAFC92B9",
      "000050CF778CC3F177C433898EE306D9BC89C89CB39A3305CFEB05372D3DBCC5F554",
      "0000EFC39EE41156787F843FF91E04E3DE1153D98FCB8B9DC49BF7CA442708FFFF45",
      "00001704C5376FB5E8DBEB9E16508ACE0200274864C9FDD85670AEC09CCC8E4514E5",
      "00008687AA0EFBB73FEFF98781BD6A51F4343DDBBC562D753CBF69AE5FBAA1276246",
      "0000DABFF316472ECEB844418CEAE29E64EDA85523BD1C11A97A75CE3E817CB19F98",
      "000031E98E88A7D1B1D297303DAFB220BD58E0DD8A8838A7030CF056EAE85CD0573A",
      "00008C63D6260133AC35AB7F28AD0BD1AE120C31B9524F7578BC0A2D6A6F672AF1C4",
      "0000E7A43EB3B46496A17BE652B4B21FFCD39FB5E28D561713852C6C0FCC70FC8F89",
      "00006E4DA4547E52A968F87DDAC072D97E3A704A4687D61D868A6F964FC2BD20AD0E",
      "00006DC3F76276C764D83005168EA30E05BC1F39AA9E1895BF75A67287565C6C5CF9",
      "0000418B4550FB1080C9EE8C0BC7AF63B215670D4AF96DFCBD8D2EC5CC2A25DE5295",
      "00001411D2A6833A10F30D24FBEB1571D05D0A94661F53E7A1FAEE4B1F55473CE850",
      "0000C0DBD66C500585ED8222CE2E9D163FF5145137823877AF6771EE6EEBD156A588",
      "0000BAB776F7D81FE91C17479A8D40DA12A7B84B410A6D6EB78A1BAE4AC8CC8D2ADF",
      "0000203B1A23F8184AF5DD00A93D0A98D2F9EE3919681B5EB8DB3AF851A7D3235F0E",
      "0000EF8B7073CFE079554B2F98DDE750C247345FE478D798F3749DEF38A645BBDD89",
      "0000971D4BDC17C820C7458BD7C61622EDB54D2030B48A7D349662A0294476EBE0C9",
      "00000E678E9511610595E87C600E459D0A26028C15E45D89C6E3568AFB084DE12C87",
      "0000CB772E5634A1A43C76B2C49F4360686D49E7ADA85750A5EB9A6549B1FF745339",
      "0000A6C6322CF6B190C999D8736607C764B83DC643C464F6E1F4E0DBB1DAEFD2766C",
      "00002E0A591FCE0EB33447896902A59209BE60F436DE613ED7BA47D171A2DFCD8797",
      "0000E26864F83B30098DEEDF74147DF97085B393239EB63B940A77D91BB731204914",
      "000049EC5E285CB9AEB89CCDA3D9C25E53ADA12B46A4D1C203AE7F928C825619099F",
      "00000089B3D639FC94D263DDCAE5962DA419CCF9F3B8C263B928BE0E6BD501EEC3B0",
      "00006F534D6B4DFE51975369D44B0CAC3B23CBBAE2A4B514DF45E2925DF7112AFC9B",
      "0000C1A62C8BB53DE15DABE7F8452E37D36F590483207FDEFD7CFE09EBDC2D15E270",
      "00006158261EE0DD94E03E43E2CE61F9448CC449B94099C76CAC03FFBA3931616CE1",
      "000023976FA4A0233B1DFFC688F852094C387728A82743D1D1C46B67EA205C56E298",
      "0000D3382B61947F6FB21667AD09F29F5670F36B4FF6186AF17F2CBF9C6CB049E741",
      "00001C9B59997ADB4C64A5A90A01884F91340CC35B25F8AFB107C4381E204C5EDE77",
      "0000F332067934217EE0227FB290AE47A79FD14A56AE5E3C4EA03490216666377C7B",
      "0000B73DFCEBBA96CF65213A8A34E2383CF51C9819D9270D1D63DC44A1E6CE6FC7BD",
      "00000E52910FD2153EA7B95C88EECA944D846C80C4D5930A795B343B3AFA60D5341F",
      "000069A5E99AE65CA62AEA59512E0DF2DBECFB24E017EA8EC869425D39B07402C43E",
      "0000BC9EDC0BA384B2F0A1A1FF8016BFD3C4AA01ECAC9321B3129708C36C7FC785EA",
      "000047DC5E1187B8B69FF21FBF8AC82A4D934271F698C285EBF32174DCED74D640F8",
      "00003B716A5A5F12011D2423ED51D435904D283EC7885860F112A68DFD2B961D7DAA",
      "0000C3908CA12F2D2C9B01FD0C8BB06F67EE5502BCD7E58C10A88A032918DB0345FB",
      "0000A8F477AB87A2CBDCB196A6280F0A22CDB6DAE5DCAF22CA9186C4897B9A0581EC",
      "000000CE7650B218DE0C5A75F9D04EC677617E8EA472A6F3EBCB14E33E24DC623CF5",
      "000050B57485DAC52FB74F585E3276010C3DEDFEEB89361E2EDE31FFA486868CEB77",
      "0000E15F4062F79E226635B95BA54DF3091F251BE5A400563CA63F86FC46453D7879",
      "0000F043C84F39A0104026F85DD49170D0FB0730F0E33BAD8BB650E1822FE2605845",
      "00003B2C1EBAE9A4D3DD905C36650F777449C5BCD9CEFAE654F29877D22F57594B11",
      "00002A5B166CAB8CC22483F42BF3724A5D50EDFFBA09EA8B12B5D2EE39751692829F",
      "0000EC9D3DB0C2DA16BE8F7C3C61AE60C72FA45D52572ED116DABDE3C8060394264A",
      "00002102E9EC4722D675B56E9E3A7821B21948407F5A328F54778AFE4CEFCC5E00EF",
      "000041B99C26F3155709DBC7D91CD09DA0F18A2AF4FCEC391B01405B26F3E3AB0335",
      "000028D5B6C679F1FE0DDC5D185F1A633D91CD5E1667E9EA78121D3CBC18E501A9C1",
      "0000970325B25D676D9D0214A96555EB6964E2A3762A216B60F2A61B08D349AF4B20",
      "00008D6CE4EC84A9AB2CA9E984ECBA16994AF6670C8C24890A72D39090D39776B034",
      "00003DD1544674DEC805E801F900F7FD6179398050788252BEC050705D4441BC5862",
      "00002BE38765235EFB94D2F53B2CDAAD8E7D408406A693A8AB7977F8A8CB2106DDC2",
      "0000C42BA3A0276F540422783A94E7182A64DB10520D24DD76D97AA4FBFD25D59205",
      "0000007EE0C82DDB109B49B8A4EE2F171CC1D00F2EA2B73FB35E0C54EF43812D5EDB",
      "0000D1937800F46E6D6DCA80D2C0D1872707DE0027F0F26D91F295C1E07E52172C53",
      "0000E569873DD4C593DC8DB3CC5571BECE7380F85132213B65C40982E7D7A31EC213",
      "00002546FD62AD3FBED84917389003C409711BCC5D571116488AC55E48B910BB6E1D",
      "0000C723109CF3B434927D3DAE511E4795EB841B1A77A54C4A5F2C62C682292A924C",
      "0000FBA2ADEFF4CADF7FF5F11FBF16323FE0BB9B3638F502F2AD5C4DF9EFD221BB9B",
      "0000CC1447830673CAD6EB25DBC61951DC7C2B7C8C80FA67A16F134DF6DE934FABB0",
      "0000CB5FB541D37E1A1AF48DB6BE6398015CDCF643523AF332074A56E4BA94A5BCD7",
      "0000290C2AF8F28E8317CC96FC4FA485793CB1B834854270C4C38F1DA4F99FEE74BF",
      "00005639DA1072E89D6935BEBC29E0EFA8F99EC48335081DC648C329B93FA6E7EDB0",
      "0000481340197DD3FF41808654FFC65CA90289B4CF37F5BA2726CD6F35D94DCB1618",
      "00004CBC4121954D8E3B17EB73314CA829492CE27BECD35B36C845A67A8F2938DBA3",
      "000089C668050C79195D86646DFE2F2C392CA616DF53285FD61FE58F74D35FABB1DD"
    ]
  end

  def prepare_query(txn_address),
    do: """
    subscription {
      transactionConfirmed(address:
        "#{txn_address}") {
        nbConfirmations
      }
    }
    """

  def await_replication(txn_address, ss_pid) do
    Task.async(fn ->
      IO.inspect(ss_pid, label: "pid id")

      PID_SubscriptionServer.subscribe(
        ss_pid,
        prepare_query(txn_address),
        _var = %{},
        _pid = self(),
        _sub_id = txn_address
      )
      receive do
        message ->
          case message do
            %{"transactionConfirmed" => %{"nbConfirmations" => 1}} -> :ok
            _data -> :error
          end

          Logger.debug("#{inspect(txn_address)}|#{inspect(message)}")
      after
        100_150_000 ->
          Logger.debug("timeout")
          :timeout
      end
    end)
  end

  def get_data() do
    [
      "0000B61478BBFA17EDD202B16F33B3761BDE850D5D75751C6112F04C8E16AFC53063",
      "0000FFEC8FCC313B83A89A3B7C24BAECA6247AE2FEB5C29E6FFDD964DF1B2A16942F",
      "00003D91891D80143B82735BBFF3152BE49C1912851452599F4AB0315A348DF3811F",
      "0000115A318AE566CD0AAD8D1068FD83842723FB645DBD8AE34B4C9B66111F6B0FAE",
      "00001C1D63A7BECF8F013B4A91F877FF448E624A4872BE2EFFD40DAACA79184313DA",
      "0000563F4BE04791B245A4E700E7F2306BE61AC6A4D2C0A211C5483C317FFE09EE8D",
      "00001321D720AE8B793F324177A50D9583C8D8065B32F0A225C3650A28EEA5FCD3AE",
      "0000F6049D48139CAF61E9A5D36BA2B9A07D2CA2D889C1EBFA43C85287637D4FDDE6",
      "000033B5FCED7B40E9BAE2B79B0EE7A2D0DF8F53B780381C16DADB126ED7BED01D12",
      "00007DB0F51C4A0D68AA3CA7D37D63BBBF1C4BDA66D6429AF68AC2BEE52797A2B982",
      "00009F4C4C85806EE44E1F7137E3D96E9C25E3772B525BD2E4CCED70CE345DFA5D33",
      "0000F614E0D818251F7DF6730EA4DADFD40C02F83075645D60C664CD9DF45303862F",
      "00005879C4027F23141CE100C9CD0B5FB9D6ADDFEA4B08A1BC8AA8F8D9022103391B",
      "00000D4FF7589952AC16FEF73C361274749FFEAF707277D807E32B4B4E3E507685DC",
      "0000B976CB1ED241163A3F91891B168AE408167D706D8879BBF2D1FBC18163F0FF09",
      "0000BE13F74FC9D2F67503B6D5F849FC631FCD89613E66789D6A680A0AA266DC3CB6",
      "0000965CA105A17ED120A9056447B4FC51D0A9FC492E9C3EE50E9626BC06BFA16AFC",
      "0000B2D3F5A916B1C03C04179634259654E8D5FD4DB1317F5EC2F2E089364D4BB71B",
      "0000A3B25C7E8E7D1735764D175D63F36088040D4F1436059B1603C2A9CF0D6BB7B7",
      "000014C0DDAE8FB68B00C4B9298572D9B05B66E7F3B2544913948FF19B4E4F6528A0",
      "00009EF754A9DB749535BC4D843BF34B55D86C6C82425EA4D3CFAD416E3504A23582",
      "00009D5A1C328FAB173991555A60B3CE68FF716F38FFC494E7B93D7AA3666A69B1A7",
      "0000A7B21A3B4C92DE9F67C7474E773AE44DA2FDCAFBE3F7A6D6F78B6B14948A056B",
      "0000D496F62FA023D03A07930432CCFF08004E81DDF9549C5EDF82A6CB62B983512F",
      "00007A4AD3E01A0D82D02BA0CCC93AFB0AE9E178827C5467710BC1B928A824A36AD7",
      "00008B44FBEEF564EE9453151E07E877BCF29C2800864A80B9567298A6E9EC3B2907",
      "0000EC79A6EB976D2F85A7BC576F3B172109FD8202636A5B741821FA831247A8652E",
      "000088143BD05CA1590C95487DAE34090B540185A6FC11532FB4D02D0CE1C6FC1270",
      "000036B17FE19B91041B14B5E18EB1C08A440CDCAADEB1B14D9C8F8AAC422E33BD50",
      "00008C6352E91F0E0A2B9035CFB897451F8602CA94AC056762F26138B1FF5BE4E8B0",
      "00001974A56E7C5028EAB368C4A0AA341A12A8332391799B696E5A2492442EEBBBB0",
      "0000D0B79CD332431339D5B3D456EE2EBD1C9BA30D7A7D0F5061604C6CDC000FAC8B",
      "0000E47AAA60B7189FC87F9E7D61AD72665ABC56EC948C6DAF134D275336CCC6101A",
      "00008C6E8B10843C0D1C253B107C2A1B2A636DC576790148687814F57BEDE845E210",
      "0000C77EB37191421666F351882896E68C24C6B898461CCE20D9F78D19FD62992CC8",
      "00007A454B21D0F9D6B9C266CA2AC5405F009587E79F739922FE4354FF69BAC292C8",
      "00007FE41C609D2BC0FBF8275BDFBD7E94D3933EB5F4BDAE063F8D0DA00EE15CFD45",
      "0000333F66FFB1E839DF1D0E2DD08DE7A3CAE1C95A00D1E92D781200231CE5459F99",
      "0000482BB849DAE8F097B0EA6CA9FB9E8E7CA8038540EF4712BA332F6DD32DBD38CB",
      "00004F343C73D9997F6B8234005995DCBA0F83BEF8C69C420F1B44475FEB5EF4126C",
      "000056F74C895CA79FF309B6589E1E27A2C03E0AA5470C6588CF1C5C288AF706682B",
      "00005FAC3D24BD324728A0820216BCA04CB5FDC34761100DBE0FD54EFC279094B259",
      "000064E3886A060157FBEBCE02811C91DED0F82BB60AFDC36A55F548EDB5C4B0F3EC",
      "0000C47F9221B7BFCC56C1ED5E68F45FC0CB82354FF3ABD7F4A977042DC59E8C9664",
      "0000688C7DADD674B071D2D7E627CBE2CE853E49DDB4D66B21515A113EC606905A2A",
      "000007CDC0FF8074CE830C4736B0CCD4414879EF49A82B7B2154F0310F08F56B80DD",
      "0000A2AE65CA6CD5C6C8FD336026D0DF1E18E30BA72D458F11E71FB3631C6C0E56A3",
      "000055D02A44C396E63ABAFAA8E1937A9CD1A94CC2BB138EB31E98FC229870EE6265",
      "0000F3E4EA00ECD342D6D1406E374264C684BEC6BFA4EB41459E00674E0A7035B580",
      "000037ED6A96B75125B8AB4A8158D0E42754D98C9A56D45CC1366A8C751D9B6A0D4C",
      "0000CC2A35D71AF8398AF05B301F4E1D68F651789054AF1509C938D45CC6F7CFFEC4",
      "00002F7ED1F116351BD36A2A331BAA867BB002F3CEF3FCCC040489330918A1C34BCE",
      "0000365F77D1D12DF125A282709F7B1E740D90BF2FA4D372852AED3103238EE0ACC9",
      "0000924701960107CA69FE715ACA4ED9510C3BE97E955FC2A579D53DCD38BBB3BED9",
      "00001C239F79577D56F805DDD767A38616B19B38362B4D8F86C911C7FAD803BA4E21",
      "00000E22FFB8B9B5B909581341A2726FAF15E063E68FD15C1CCE85ACA7FFDE182D84",
      "0000870DFF9CB3135AB7A0E35B26AFBF554898B90EA3F52BEF5486E656F29184A02C",
      "0000DB5AAAFB739CA6608807BDA4D83B33D2776B2ECFF730859DB7BC57C785195A58",
      "00001AA5D639370A6F751C4D9A62D15B422EDE0CAF63A33AA226F58B1AA05A6942A7",
      "000004029B2D614E2B82F2579974383023211C2C7F241F0F1CDB3D240AD5BD1C129A",
      "0000BE5AD438B0EA5EF5817EA65394BA37E0D9630BCBD12D4E79BBEE5F2B1560549D",
      "0000FC2CD38375699B187805A4E15D71535E7356C84C162255EFB2D921E229AFA75D",
      "000088317514A986D60617500B16661F4BDCDC2149C1BA4D96410DC7A9EACA613439",
      "00002FBA374DC6CFE0B0CEC2D45B999717D5F97AE4354D25ADC08D9B7BB1E90554CB",
      "0000A61ABA78D78C24A89D51EF99A8A4602411F8C3B40268AF6DE7B8D524B8AE16A9",
      "0000F005DFCE3BC360B625314F6D4422373D63A6521CB06794DB954F3DCABB09CADC",
      "00007A27F527FF671BF1634FFFED66E0D88977AE9F18CB37ECA884B6E3B48CC21FF2",
      "00001FA66F2001A4776F3A04DDB8336F15F550F18A8CA5B460CABAF61C56E2512B24",
      "0000A66BC1F30B8382B242244E1D72596CC9841E3C994F277D7E96D323B48463180E",
      "00004189A726AA90015ADFE12579291B2F0CF4C8E3DD8FA557A6B51497DAE2089F9D",
      "000090A8673D8D176FF10D27AE8B33947B75E282F814114B592C377F68DA7BAF76E3",
      "0000482BCC8100530462998C7B8658912F19FB67334CF2B3CD13EE1BF7E43967088C",
      "0000C50C3F1B0FDC60CA6CFEDDAFB7EB7112C19857F220E5AC649E5421B19044C16A",
      "00006ED5A08C168F20739D5B2893D16BF7E27B81437D931FE4B94378488AC12855B6",
      "0000C991B3279A36DEADCC6D825990644E53452A5EE70BA7694A809B2D6943D14588",
      "00005FBDF613D53F3E1213AAB74C6446AD21A3CFD54C9F21B4AF6E7E51340B89EBEA",
      "000033E1F83BEFB71683746F3BB3F224B986D08A2B99298D602E3F606C938D822BD7",
      "000032775D5BE406F0972F1D8A53075773206D60F5DD7D4BB0F9DB1D4ABC226ED8AF",
      "0000D5D2C570C0490ED873D018E4D0F79EA2A888A67AB531964B34112A8E5CEB645F",
      "0000C4C42ACC166CDCEECADA4D16AA26C057581D3BF2ACCAC4D5DA5F0542AA0B33BC",
      "00007903F8935D0FD46EE37BEC16DEF99B4709E5475C090333E3E4934B9E26BBE8EE",
      "000097778FD8BA80CFE3CB6B992470F4886E7131E13AB0996C646B1379A1D138E327",
      "000041CAEC5BC58073C82D465EDA7B3E3A6E5A1A09B5338B75DBE0138338BDAC88F7",
      "0000380133ED9BF5039D712B2795B2F39DA1B9EC60FCFF9682E0AB465649B6E8461E",
      "0000CE7FA5B94A6F7C06600E68B0E03F484B13F21A962D662CA057806DF9BC474356",
      "000085CEC42833676CA07F5236CED2C0F19F8DEB226ED43B6F51E1B9B34804396723",
      "000067A2E0422B513290DF695EC91B58EF5A507ECA2C57AF6CC1D6B95251C6BEFEB1",
      "000011E8AE2E0D479DC5F42AB38F0804A7E74C06CABE409AFA66F1F4A9E08C88662A",
      "0000DB0BD6498BB4AF365F9B07388B4335C09910A05EE8BE0941B36A3F56BB442CA6",
      "000096CB02C7751585CC666F2B5DC0B6D1907F86D5D14E823810B7E7242AEF8A00AD",
      "0000D4100467653922E732ED76F5817D307B8AD8BCBD9F58E63988EC9830C7DF6254",
      "0000DAB35559BCE320EC9A1F6B4D15B7F19DFA06E1EAFE96C5DB524070C55CAA827A",
      "0000EDCB5A399A7FA73C043B06C35270E94B720742F73503A690B633B36F3E976CEE",
      "0000BA5E8DB36295B7E981552FB7FAAC586B25E87FEF49982C526FFF2B81188971F0",
      "0000EDE6482AA370F8056CE44644B1378BC411577A1AAA1ACA84938B8185ADF9B4D3",
      "0000CE45F81710E0063CA1915B3EF624987653466FDB0C3CD60EE047CBD9F928AC1F",
      "00009BC18522FDB3C8FD345E9F94984CA75E966160E3F8D591736E8640C5BA85CF28",
      "00000BABD71AF8E2BD186BC9B111907AF2B391B16267BEB87A6ADDAA15F6244CF834",
      "0000D4AA3F3DB629E0D007E79DBB8C4708DDA313203E2459E2E067C64E7666881B3B",
      "00007F06E0A1B4636F2195BCB834CDB27DDEABC7B78EB271F8EF211E5CA8CA9B5345",
      "00006E5EFF35ACE5EC0812787C720D526EC0ED0BB1C1097E47FE14F86C9760A25078",
      "000031D26CF7FC37E3278572328595CC4B16C47C0561F27EB8C574785336C578A323",
      "00008441D5D6BEEE918A0FE246682D3BBBEB9CFCD06542B7F0EBACD5C835CF297599",
      "00004E04E92163B7E9C943047D2857790B486B84EFEC4C7534A1889C97FBF2ABA749",
      "0000DD65FEEE56C3CAAD62FDB346D8D27A47AD99AC5F9EF96AA4BDAA698678D4A4F2",
      "00005461FD28B7C05B31A81E6B063450CA9855AD3E0D0D4FD83D447A2CF464FA9038",
      "000009ED43A7BABE90305E72DFD97A80D3B170A494C3B7B39BEFE13C0A7C9DA61610",
      "0000F3BE98E61E28AB71D704751431B2DE2844028C8171A978901FE08B249D4143EC",
      "000091AE2659A60473F49F4935F802F53170D8499CA05143AA84CC99EA5D9DA64358",
      "00009391AFF32B600B17D148F8E41BDF3C848D282DD7EB05FC03597A97617069F6F1",
      "0000889C95B7E06E61FC1ED014CB3BEAB9FA2951F32D9029FED8DF146098265BE547",
      "00006008E53DA79099475A350096F5165A37AF5D0EB94E37991B9D4B68F8ECDA6265",
      "000049D425BF14C0BC5CC757DA9F899594ABBDC4C6FD8A2DC1BD17577CBCAB279EE0",
      "00001C4E647D2CE446E10027C77049E7581D14350D7A6CA7119AB45ED2D0EACD5BB7",
      "000049893EE70CD59B571AB3C16746349101196475409B5FEA9FDAB898D5DB154B1B",
      "0000653ECF43C699D7DF91654F3E4544289E5ABFE15E4FC28A0DF0B395AD44FFE4FE",
      "00004787D44BD70F85728EFC0079C120FEF44D5EDC3DD952689FEC7F6ED10D8ECC7A",
      "0000EB754481E964B07163E714163927F3C8184E79F49F05C38311631B8866568ED8",
      "0000AE492422E53142B81B9AAE5269E07A577995902CD4AF417C4DE3C2620059C005",
      "00000F5335F87FFAD426F978EF6801BDCC9F834DA535F5EDA3365E0F8AC3E41C8233",
      "000011928F6093C7F9E19592CDEE4B2BF3B6050F508E072CCD3D6A85E3182FA81742",
      "0000AC49523FED990E174281A16427F86623E0A0B257C9AC231749FDAA86947CA565",
      "00001FD5AE96714871A015C7B69E3DE7B8406568D8A1AF4AC121EE48BAAC10FAE516",
      "0000903E3CE423FEBDDE394138D343B0FC5389A0440274FF350376B204EC94477FC7",
      "00001356B5F2936E5948DF21C1FE0C66F0B37F937F680AD66F61FFEE30D28511213E",
      "0000BD38C7B4C0888CB8BE1E99DC65840CB9BC4DB0B8B538022E4A0C5C0358EA7FA7",
      "000067739A72A96C4F6963F8A1CA3F607BF1CEC205EA594371EBE490493A13339612",
      "000014328FB18B2D75D10D985B26C8CDC10B84547E3A1DEE1723C2A3B473FAD6D95A",
      "0000A62590E3FFBD48A9517828F45505781253770D710BCEC0CA56A81DAB0EE5C25A",
      "0000F1324DFABAD25EC9AB5AB390DD2AFE8691242F9FE0AC1973C579BC6F4F3E31DA"
    ]
  end
end
