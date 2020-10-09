clear
[heart_scale_label, heart_scale_inst] = libsvmread('F:/libsvm-3.22/heart_scale');
model = libsvmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07');
[predict_label, accuracy, dec_values] = libsvmpredict(heart_scale_label, heart_scale_inst, model);
