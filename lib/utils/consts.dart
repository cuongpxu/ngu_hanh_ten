
const appTitle = "Đặt tên ngũ hành";

const nguHanhPageTitle = "Đặt tên theo Ngũ hành";
const tenHayPageTitle = "TÌM TÊN THEO NGŨ HÀNH";
const goiyPageTitle = "GỢI Ý TÊN THEO NGŨ HÀNH";
const favoritePageTitle = "DANH SÁCH CÁC TÊN ĐÃ LƯU";

const nguHanhDetailPageTitle = "Phân tích ngũ hành";
const goiyDetailPageTitle = "Gợi ý tên theo ngũ hành";
const listSuggestedNameTitle = "Một số tên hợp ngũ hành";
const listSuggestedNameDisclaimerTitle = "Lưu ý: Những tên này được lựa chọn ngẫu nhiên sao cho phù hợp với ngũ hành. Nếu chưa chọn được tên ưng ý bạn có thể chọn xem thêm hoặc tìm tên theo mệnh trong tính năng tìm tên.";
const tongQuanTitle = "Tổng quan";
const nguHanhTuoiTitle = "Ngũ hành theo tuổi";
const luanGiaiChiTietTitle = "Luận giải chi tiết";
const solarDateTitle = "Dương lịch";
const lunarDateTitle = "Âm lịch";
const nienMenhTitle = "Niên mệnh";
const menhTitle = "Mệnh";

const scoreTitle = "Điểm";
const totalScoreTitle = "Tổng điểm: ";
const conclusionTitle = "Kết luận: ";
const concludeTitle = "Kết luận";
const gender = "Giới tính:";
const male = "Nam";
const female = "Nữ";

const surname = "Họ (bao gồm cả họ ghép)";
const surnameHint = "Xin mời nhập họ!";
const surnameError = "Họ phải chứa ít nhất 2 ký tự!";

const firstname = "Tên (bao gồm cả tên đệm)";
const firstnameHint = "Vui lòng nhập tên!";
const firstnameError = "Họ phải chứa ít nhất 2 ký tự!";

const kidYearBorn = "Ngày sinh con (Dương lịch)";
const dadYearBorn = "Ngày sinh cha (Dương lịch)";
const momYearBorn = "Ngày sinh mẹ (Dương lịch)";
const dateBornHint = "Xin mời nhập ngày sinh!";

const hourBorn = "Giờ sinh";
const hourBornHint = "Xin mời nhập giờ sinh!";

const fullnameTitle = "Họ tên";
const fullnameError = "Vui lòng nhập họ tên!";

const addressTitle = "Địa chỉ";
const addressError = "Vui lòng nhập địa chỉ!";

const birthYearTitle = "Ngày sinh";
const birthYearError = "Vui lòng nhập ngày sinh!";

const submitButtonTitle = "Lưu";
const successfulSaveMessage = "Cập nhật thông tin thành công.";
const failedSaveMessage = "Lỗi cập nhật thông tin.";

const noDataMessage = "Không có dữ liệu!";
const checkNameTitle = "Xem tên";
const suggestTitle = "Gợi ý";
const findTitle = "Tìm tên";
const favoriteTitle = "Yêu thích";
// Ngu hanh
const kl_hoa_1 = "nên không sinh, không khắc, chỉ ở trung bình";
const tuong_sinh = "tương sinh";
const tuong_khac = "tương khắc";
const not_sinh_khac = "không sinh, không khắc";

const kl_tot = "rất tốt";
const kl_tot_act = "nên";
const kl_xau = "rất xấu";

const kl_trung_binh = "chỉ ở mức trung bình";
const kl_hoa = "bình hòa";

const undefined_type = "không xác định";

const expectedNameTitle = "Tên dự kiến đặt cho con: ";

const NGU_HANH = ["Kim", "Mộc", "Thủy", "Hỏa", "Thổ"];
const KIM = "Kim";
const MOC = "Mộc";
const THUY = "Thủy";
const HOA = "Hỏa";
const THO = "Thổ";
const ALL = "Tất cả";

// TenHayPage
const allType = "Tất cả";

// GoiYPage
const suggestButton = "Xem gợi ý";

const noData = "Không có dữ liệu!";
const exitTitle = "Nhấn lần nữa để thoát!";

const infor1 = "Việc đặt tên cho con cái không chỉ là một việc trọng đại mà còn mang một ý nghĩa rất quan trọng cho mỗi cặp vợ chồng khi sinh con. Cái tên sẽ đi theo con suốt một đời người, cho nên việc chọn tên phải làm sao thu hút được vận may và phúc đức cho con cái. Ngoài ra, tên con cũng không nên khắc tên bố mẹ mà cần tương sinh cho gia đình thuận hòa. Vậy đặt tên cho con hợp theo ngũ hành như thế nào?";
const infor2 = "Để chọn tên phù hợp với con thì bạn hãy lấy Niên mệnh của con bạn làm chủ. Thông thường mỗi một hành thì sẽ có hai hành tương sinh và một hành bình hòa, chúng tôi nêu ví dụ cho bạn dễ hiểu. Ví dụ: con của bạn có niên mệnh là Thổ thì hai hành tương sinh phải là Kim và Hỏa và 1 hành bình hòa là Thổ, như vậy tên đặt cho con của bạn nên chọn trong các hành Kim, Hỏa hoặc Thổ. Việc chọn tên có hành Kim và Hỏa để tương sinh cho hành Thổ của con bạn là việc quá dễ, nhưng điều khó là nó phải tương sinh luôn với ngũ hành của cha và mẹ thì mới thật sự là tốt.";
const infor3 = "Vậy bạn hãy ưu tiên chọn tên cho con của bạn bằng một trong hai hành Kim và Hỏa, tùy theo hành nào hợp với niên mệnh của bạn là tốt, hoặc bất quá là hành Thổ bình hòa nhé. Nếu con bạn sống chung với cha mẹ thì ưu tiên chọn tên có hành tương sinh với niên mệnh cha, còn nếu sống riêng theo ai, cha hoặc mẹ thì chọn tên có hành tương sinh với niên mệnh người đó, nếu tên con được tương sinh cả niên mệnh cha và mẹ thì cực kỳ tốt.";
const infor4 = "Ứng dụng \"Đặt tên theo Ngũ Hành\" là một công cụ mang tính tham khảo, để giúp các bậc cha mẹ có một định hướng khi đặt tên cho con.";

const interstitialProb = 0.4;